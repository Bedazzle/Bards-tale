#!/usr/bin/env python3
"""
bardstale_imagecodec.py — Image format tools for Bard's Tale ZX Spectrum.

Subcommands:
  extract-icons  — render gfx/98DF-9AA6__icons.asm to PNG
  extract-font   — render gfx/FC38-FCE1__partial_font.asm to PNG
  decompress-pic — given an .asm data file or raw bytes, decompress a picture
                   and write the raw 1024-byte output (for further analysis)
  render-pic     — given compressed picture bytes, render to PNG using the
                   2-pass screen-writer geometry from show_pic_by_A
  extract-all    — extract all 20 location pictures + 13 monster portraits
                   from the game binary to a directory
"""
import argparse
import os
import re
import sys

try:
    from PIL import Image
except ImportError:
    print("Requires Pillow: pip install Pillow", file=sys.stderr)
    sys.exit(1)


# ----- ZX Spectrum colour palette -----

ZX_COLORS_NORMAL = [
    (0, 0, 0),       # 0 black
    (0, 0, 215),     # 1 blue
    (215, 0, 0),     # 2 red
    (215, 0, 215),   # 3 magenta
    (0, 215, 0),     # 4 green
    (0, 215, 215),   # 5 cyan
    (215, 215, 0),   # 6 yellow
    (215, 215, 215), # 7 white
]

ZX_COLORS_BRIGHT = [
    (0, 0, 0),       # 0 black
    (0, 0, 255),     # 1 blue
    (255, 0, 0),     # 2 red
    (255, 0, 255),   # 3 magenta
    (0, 255, 0),     # 4 green
    (0, 255, 255),   # 5 cyan
    (255, 255, 0),   # 6 yellow
    (255, 255, 255), # 7 white
]

# Default picture attribute: set by sub_64FB before show_pic_by_A draws.
# 0x39 = ink 1 (blue), paper 7 (white), bright 0, flash 0.
PICTURE_ATTR = 0x39


# ----- ASM byte parsing -----

def parse_asm_bytes(path):
    """Extract all `db` bytes from a sjasmplus-format .asm file."""
    out = []
    with open(path) as f:
        for line in f:
            code = line.split(';')[0]
            if not re.search(r'\bdb\b', code, re.IGNORECASE):
                continue
            code = re.sub(r'^\s*\w*:?\s*db\s*', '', code, flags=re.IGNORECASE)
            for tok in code.split(','):
                tok = tok.strip()
                if not tok:
                    continue
                m = re.match(r'^\$([0-9A-Fa-f]+)$', tok)
                if m:
                    out.append(int(m.group(1), 16))
                    continue
                m = re.match(r'^0?([0-9A-Fa-f]+)h$', tok)
                if m:
                    out.append(int(m.group(1), 16))
                    continue
                m = re.match(r'^(\d+)$', tok)
                if m:
                    out.append(int(m.group(1)))
                    continue
    return out


# ----- Glyph rendering -----

def render_glyph_grid(bytes_, scale=4, cols=16, margin=2, bg=(50, 50, 50)):
    """Render an array of 8-byte 1bpp glyphs to a grid PNG."""
    n = len(bytes_) // 8
    rows = (n + cols - 1) // cols
    cell = 8 * scale
    img = Image.new(
        'RGB',
        (cols * (cell + margin) + margin, rows * (cell + margin) + margin),
        bg,
    )
    for i in range(n):
        gr = i // cols
        gc = i % cols
        x0 = margin + gc * (cell + margin)
        y0 = margin + gr * (cell + margin)
        for py in range(8):
            b = bytes_[i * 8 + py]
            for px in range(8):
                bit = (b >> (7 - px)) & 1
                color = (255, 255, 255) if bit else (0, 0, 0)
                for sy in range(scale):
                    for sx in range(scale):
                        img.putpixel((x0 + px * scale + sx, y0 + py * scale + sy), color)
    return img


# ----- Picture decompression -----

def decompress_pic_stream(data, max_out=860):
    """
    Decompress a Bard's Tale picture bytestream.

    Algorithm: byte 0 = RLE escape marker. Subsequent bytes are emitted
    directly (XOR'd with 0xFF -- the cpl in the original asm). When the
    marker appears, read length and value; emit (length+3) copies of
    (value XOR 0xFF).

    Returns (decompressed_bytes, input_bytes_consumed).
    """
    if not data or len(data) < 2:
        return None, 0
    marker = data[0]
    out = bytearray()
    src = 1
    while len(out) < max_out and src < len(data):
        b = data[src]
        src += 1
        if b == marker:
            if src + 1 >= len(data):
                break
            length = data[src]
            src += 1
            value = data[src]
            src += 1
            count = length + 3
            for _ in range(count):
                out.append(value ^ 0xFF)
                if len(out) >= max_out:
                    break
        else:
            out.append(b ^ 0xFF)
    return bytes(out[:max_out]), src


# ----- Spectrum screen geometry for picture rendering -----

def down_hl_BT(addr):
    """
    Emulate simple_down_hl at $89B0.

    Advances the screen pointer by one pixel row within the ZX Spectrum
    screen layout.  Handles character-cell and third boundary wrap.

    Address format: 010 TT YYY BBBBB XXXXX
      TT    = third (0-2)
      YYY   = sub-row within character cell (0-7)
      BBBBB = character row within third (0-7)
      XXXXX = byte column (0-31)
    """
    h = (addr >> 8) & 0xFF
    l = addr & 0xFF
    if (h & 0x47) != 0x47:
        return (addr + 0x100) & 0xFFFF
    if (l & 0xE0) == 0xE0:
        return (addr + 0x20) & 0xFFFF
    return (addr - 0x06E0) & 0xFFFF


def addr_to_xy(addr):
    """
    ZX Spectrum pixel address -> (byte_x, pixel_y).

    Address format: 010 TT YYY BBBBB XXXXX
      pixel_y = TT*64 + BBBBB*8 + YYY
    """
    o = addr - 0x4000
    if not (0 <= o < 0x1800):
        return None
    x = o & 0x1F
    block_y = (o >> 5) & 7     # BBBBB: character row within third
    bit_y = (o >> 8) & 7       # YYY:   sub-row within character cell
    third = (o >> 11) & 3      # TT:    third (0-2)
    return (x, (third << 6) | (block_y << 3) | bit_y)


def _decompress_to_screen(compressed):
    """
    Faithfully emulate show_pic_by_A's decompression loop.

    Returns dict {spectrum_addr: byte_value} of all screen writes.
    """
    if not compressed or len(compressed) < 2:
        return {}, 0

    marker = compressed[0]
    src = 1
    screen = {}
    hl = 0x4021
    b_alt = 0
    c_alt = 0
    e_alt = 0
    h_storage = 0
    pass_count = 0

    while pass_count < 2 and src < len(compressed):
        if e_alt == 0:
            if src >= len(compressed):
                break
            byte_in = compressed[src]
            src += 1
            if byte_in == marker:
                if src + 1 >= len(compressed):
                    break
                length = compressed[src]
                src += 1
                value = compressed[src]
                src += 1
                e_alt = length + 3
                h_storage = value
                continue
            a_val = byte_in
        else:
            e_alt -= 1
            a_val = h_storage

        screen[hl] = a_val ^ 0xFF
        hl = down_hl_BT(hl)
        hl = down_hl_BT(hl)
        b_alt += 2
        if b_alt >= 0x56:
            b_alt -= 0x56
            c_alt += 1
            hl = (hl - 0x0E3F) & 0xFFFF
            if c_alt == 0x0A:
                c_alt = 0
                pass_count += 1
                if pass_count >= 2:
                    break
                hl = (hl + 0xFFF6) & 0xFFFF
                hl = down_hl_BT(hl)
                b_alt = 1

    return screen, src


def render_compressed_pic(compressed, attr=PICTURE_ATTR):
    """
    Faithfully emulate show_pic_by_A and produce a Spectrum screen image.

    The picture occupies byte columns 1-10, pixel rows 8-93 (86 rows,
    10 columns = 80x86 native pixels).

    Args:
        compressed: raw picture data (first byte = RLE marker)
        attr: ZX Spectrum attribute byte for the picture area.
              Default 0x39 = blue ink on white paper (set by sub_64FB).

    Returns (PIL.Image cropped to picture region, input_bytes_consumed).
    """
    screen, src = _decompress_to_screen(compressed)
    if not screen:
        return None, 0

    ink_idx = attr & 7
    paper_idx = (attr >> 3) & 7
    bright = (attr >> 6) & 1
    ct = ZX_COLORS_BRIGHT if bright else ZX_COLORS_NORMAL
    ink_color = ct[ink_idx]
    paper_color = ct[paper_idx]

    # Picture area: byte cols 1-10, pixel rows 8-93 -> 80x86 native pixels
    pic_w, pic_h = 80, 86
    img = Image.new('RGB', (pic_w, pic_h), paper_color)
    px = img.load()

    for addr, val in screen.items():
        if not (0x4000 <= addr < 0x5800):
            continue
        xy = addr_to_xy(addr)
        if not xy:
            continue
        bx, y = xy
        ix = (bx - 1) * 8   # picture-relative x (col 1 -> pixel 0)
        iy = y - 8           # picture-relative y (row 8 -> pixel 0)
        if not (0 <= ix < pic_w and 0 <= iy < pic_h):
            continue
        for bit in range(8):
            pixel_set = (val >> (7 - bit)) & 1
            px[ix + bit, iy] = ink_color if pixel_set else paper_color

    return img, src


def render_compressed_pic_fullscreen(compressed, attr=PICTURE_ATTR):
    """Render to a full 256x192 Spectrum screen (for debugging)."""
    screen, src = _decompress_to_screen(compressed)
    if not screen:
        return None, 0

    ink_idx = attr & 7
    paper_idx = (attr >> 3) & 7
    bright = (attr >> 6) & 1
    ct = ZX_COLORS_BRIGHT if bright else ZX_COLORS_NORMAL
    ink_color = ct[ink_idx]
    paper_color = ct[paper_idx]

    img = Image.new('RGB', (256, 192), (0, 0, 0))
    px = img.load()

    # Fill picture area background with paper
    for char_row in range(1, 12):
        for sub_row in range(8):
            y = char_row * 8 + sub_row
            for byte_col in range(1, 11):
                for bit in range(8):
                    x = byte_col * 8 + bit
                    if 0 <= x < 256 and 0 <= y < 192:
                        px[x, y] = paper_color

    for addr, val in screen.items():
        if not (0x4000 <= addr < 0x5800):
            continue
        xy = addr_to_xy(addr)
        if not xy:
            continue
        bx, y = xy
        for bit in range(8):
            x = bx * 8 + bit
            pixel_set = (val >> (7 - bit)) & 1
            if 0 <= x < 256 and 0 <= y < 192:
                px[x, y] = ink_color if pixel_set else paper_color

    return img, src


# ----- Picture pointer table -----

# ___table_58 at $C288 holds 16-bit pointers to compressed picture data.
# Index by pic_id: pointer = word at table_58 + 2*pic_id.
TABLE_58_ADDR = 0xC288

# All picture IDs in the pointer table (pic_id -> name).
# Entries sharing the same data pointer are noted as duplicates.
PIC_NAMES = {
    0x00: 'pic_00',
    0x01: 'pic_01',
    0x02: 'pic_roscoes',
    0x03: 'pic_zombie',
    0x04: 'pic_04',
    0x05: 'pic_05',
    0x06: 'pic_06',
    0x07: 'pic_07',
    0x08: 'pic_08',
    0x0B: 'pic_0B',
    0x0D: 'pic_guild',
    0x0E: 'pic_shoppe',
    0x0F: 'pic_tavern',
    0x10: 'pic_10',
    0x11: 'pic_temple',
    0x12: 'pic_building',
    0x13: 'pic_reviewboard',
    0x14: 'pic_14',
    0x1A: 'pic_guardian',
    0x1B: 'pic_tower',
}

# Monster image indices: MONST_IMAGE values 0x00-0x0C map to the same
# picture pointer table (___table_58) at those pic_id values.
MONSTER_IMAGE_IDS = list(range(0x0D))  # 0..12

MONSTER_NAMES = {
    0x00: 'monster_00',
    0x01: 'monster_01',
    0x02: 'monster_02',
    0x03: 'monster_zombie',
    0x04: 'monster_04',
    0x05: 'monster_05',
    0x06: 'monster_06',
    0x07: 'monster_07',
    0x08: 'monster_08',
    0x09: 'monster_09',
    0x0A: 'monster_0A',
    0x0B: 'monster_0B',
    0x0C: 'monster_0C',
}


def load_game_memory(bin_path):
    """Load the game binary (game_5B00-FFFF.mem) into a 64K array."""
    mem = bytearray(65536)
    with open(bin_path, 'rb') as f:
        data = f.read()
    # Auto-detect base address from file size
    if len(data) == 42240:  # 0xFFFF - 0x5B00 + 1
        mem[0x5B00:0x5B00 + len(data)] = data
    elif len(data) == 65536:
        mem[:] = data
    else:
        # Assume it's the recompile/bt.bin (same content)
        mem[0x5B00:0x5B00 + len(data)] = data
    return mem


def get_pic_pointer(mem, pic_id):
    """Read the compressed-data address for a picture from ___table_58."""
    offset = TABLE_58_ADDR + pic_id * 2
    return mem[offset] | (mem[offset + 1] << 8)


def get_unique_pictures(mem):
    """Return {pic_id: (name, data_addr)} for all unique pictures."""
    seen_addrs = {}
    result = {}
    for pic_id in range(0x1C):
        addr = get_pic_pointer(mem, pic_id)
        if addr < 0x5B00 or addr >= 0xFFFF:
            continue
        if addr in seen_addrs:
            continue
        name = PIC_NAMES.get(pic_id, f'pic_{pic_id:02X}')
        seen_addrs[addr] = pic_id
        result[pic_id] = (name, addr)
    return result


# ----- Subcommands -----

def cmd_extract_icons(args):
    bytes_ = parse_asm_bytes(args.input)
    n = len(bytes_) // 8
    print(f'{args.input}: {len(bytes_)} bytes -> {n} 8x8 glyphs')
    img = render_glyph_grid(bytes_, scale=args.scale, cols=args.cols)
    img.save(args.output)
    print(f'wrote {args.output} ({img.size[0]}x{img.size[1]})')


def cmd_extract_font(args):
    cmd_extract_icons(args)  # same format


def cmd_decompress_pic(args):
    if args.input.endswith('.asm'):
        bytes_ = parse_asm_bytes(args.input)
    else:
        with open(args.input, 'rb') as f:
            bytes_ = list(f.read())
    out, used = decompress_pic_stream(bytes(bytes_), max_out=args.target)
    if out is None:
        print('decompression failed', file=sys.stderr)
        sys.exit(1)
    print(f'consumed {used} input bytes, produced {len(out)} output bytes')
    print(f'marker byte: ${bytes_[0]:02X}')
    with open(args.output, 'wb') as f:
        f.write(out)
    print(f'wrote {args.output}')


def cmd_render_pic(args):
    if args.input.endswith('.asm'):
        bytes_ = parse_asm_bytes(args.input)
    else:
        with open(args.input, 'rb') as f:
            bytes_ = list(f.read())
    img, used = render_compressed_pic(bytes(bytes_), attr=args.attr)
    if img is None:
        print('render failed', file=sys.stderr)
        sys.exit(1)
    print(f'consumed {used} input bytes')
    if args.scale > 1:
        img = img.resize(
            (img.size[0] * args.scale, img.size[1] * args.scale),
            Image.NEAREST,
        )
    img.save(args.output)
    print(f'wrote {args.output} ({img.size[0]}x{img.size[1]})')


def cmd_extract_all(args):
    """Extract all pictures from the game binary."""
    mem = load_game_memory(args.binary)
    os.makedirs(args.outdir, exist_ok=True)

    scale = args.scale
    attr = args.attr

    # Extract all unique location pictures
    pictures = get_unique_pictures(mem)
    print(f'Found {len(pictures)} unique pictures in pointer table')
    print()

    for pic_id in sorted(pictures.keys()):
        name, addr = pictures[pic_id]
        compressed = bytes(mem[addr:addr + 1024])
        img, used = render_compressed_pic(compressed, attr=attr)
        if img is None:
            print(f'  [{pic_id:02X}] {name}: FAILED')
            continue
        if scale > 1:
            img = img.resize(
                (img.size[0] * scale, img.size[1] * scale),
                Image.NEAREST,
            )
        out_path = os.path.join(args.outdir, f'{name}.png')
        img.save(out_path)
        is_monster = pic_id in MONSTER_IMAGE_IDS
        tag = ' [monster portrait]' if is_monster else ''
        print(f'  [{pic_id:02X}] {name}: ${addr:04X}, {used} bytes consumed{tag} -> {out_path}')

    # Summary of monster-to-image mapping
    print()
    print('Monster portrait mapping (MONST_IMAGE values 0x00-0x0C):')
    for mid in MONSTER_IMAGE_IDS:
        if mid in pictures:
            name, addr = pictures[mid]
            print(f'  monster image {mid:02X} -> {name} (${addr:04X})')
        else:
            # Find which picture it duplicates
            addr = get_pic_pointer(mem, mid)
            dup_name = '(shared data)'
            for pid, (pname, paddr) in pictures.items():
                if paddr == addr:
                    dup_name = f'same as {pname}'
                    break
            print(f'  monster image {mid:02X} -> ${addr:04X} ({dup_name})')

    print()
    print(f'All pictures saved to {args.outdir}/')


def main():
    p = argparse.ArgumentParser(description=__doc__,
                                formatter_class=argparse.RawDescriptionHelpFormatter)
    sub = p.add_subparsers(dest='cmd', required=True)

    pi = sub.add_parser('extract-icons', help='render icons sheet to PNG')
    pi.add_argument('input', help='gfx/98DF-9AA6__icons.asm')
    pi.add_argument('output', help='output PNG path')
    pi.add_argument('--scale', type=int, default=4)
    pi.add_argument('--cols', type=int, default=16)
    pi.set_defaults(func=cmd_extract_icons)

    pf = sub.add_parser('extract-font', help='render partial font to PNG')
    pf.add_argument('input', help='gfx/FC38-FCE1__partial_font.asm')
    pf.add_argument('output', help='output PNG path')
    pf.add_argument('--scale', type=int, default=4)
    pf.add_argument('--cols', type=int, default=16)
    pf.set_defaults(func=cmd_extract_font)

    pd = sub.add_parser('decompress-pic',
                        help='decompress picture bytes (.asm or raw .bin)')
    pd.add_argument('input', help='compressed picture data')
    pd.add_argument('output', help='output raw bytes')
    pd.add_argument('--target', type=int, default=860,
                    help='expected output size (default 860 for full picture)')
    pd.set_defaults(func=cmd_decompress_pic)

    pr = sub.add_parser('render-pic',
                        help='decompress and render to PNG via screen-writer geometry')
    pr.add_argument('input', help='compressed picture data')
    pr.add_argument('output', help='output PNG path')
    pr.add_argument('--scale', type=int, default=3)
    pr.add_argument('--attr', type=lambda x: int(x, 0), default=PICTURE_ATTR,
                    help='attribute byte (default 0x39 = blue ink, white paper)')
    pr.set_defaults(func=cmd_render_pic)

    pa = sub.add_parser('extract-all',
                        help='extract all pictures from game binary')
    pa.add_argument('binary', help='path to game_5B00-FFFF.mem or bt.bin')
    pa.add_argument('outdir', help='output directory for PNGs')
    pa.add_argument('--scale', type=int, default=3,
                    help='pixel scale factor (default 3)')
    pa.add_argument('--attr', type=lambda x: int(x, 0), default=PICTURE_ATTR,
                    help='attribute byte (default 0x39 = blue ink, white paper)')
    pa.set_defaults(func=cmd_extract_all)

    args = p.parse_args()
    args.func(args)


if __name__ == '__main__':
    main()
