# Bard's Tale (ZX Spectrum, 1988) — Image Formats

Reverse-engineered from the disassembly at
[github.com/Bedazzle/Bards-tale](https://github.com/Bedazzle/Bards-tale).

This document covers the **image data formats** in the game. Three distinct
formats are used:

1. **Icons** — small 8×8 1bpp glyphs for UI symbols and dungeon-view sprite
   parts (status icons, arrows, weapon/figure tiles)
2. **Partial font** — 8×8 1bpp glyphs for a subset of the game's character
   set (used by the print-buffer routines)
3. **Pictures** — large RLE-compressed scenes (taverns, temples, monster
   portraits, etc.) drawn into an 80×86 portion of the upper screen

## 1. Icons

**Location:** `gfx/98DF-9AA6_icons.asm` (`$98DF`-`$9AA6`, 456 bytes)

**Format:** flat array of 8-byte glyphs, 1bpp, MSB-leftmost.

Each glyph is 8 bytes, one byte per pixel row, top to bottom. Bit 7 of
each byte = leftmost pixel; bit 0 = rightmost pixel; bit set = ink, bit
clear = paper.

```
SYMBOL_ZERO:
    DB $38  ; ..###...
    DB $4C  ; .#..##..
    DB $54  ; .#.#.#..
    DB $54  ; .#.#.#..
    DB $54  ; .#.#.#..
    DB $64  ; .##..#..
    DB $38  ; ..###...
    DB $00  ; ........
```

**Total icons:** 57 glyphs in the original game.

The first three are explicitly labeled (`SYMBOL_ZERO`, `SYMBOL_EMPTY`,
`SYMBOL_CROSS`); the rest are in an unlabeled `ICONS` block and are
referenced by index.

Renders cleanly with the simple decoder: read 8 bytes, plot 8×8 grid.

## 2. Partial font

**Location:** `gfx/FC38-FCE1_partial_font.asm` (`$FC38`-`$FCE1`, 170 bytes)

**Format:** identical to icons — flat array of 8-byte 1bpp glyphs.

**Total characters:** 21 glyphs. Includes uppercase A-P plus a few
punctuation marks. The "partial" name reflects that this is only a
subset of the printable character set; other glyphs come from ROM or
elsewhere.

Renders cleanly with the same decoder as icons.

## 3. Pictures (full scenes)

**Format:** RLE-compressed bitstream that decompresses to 860 bytes of
pixel data, painted into an 80×86 pixel area of the Spectrum screen with a
2-pass interleaved column/row order.

### Attribute colours

All pictures share a single uniform attribute byte `$39`, set by
`sub_64FB` (`code/64F3-6569_city_colors.asm`) before `show_pic_by_A`
draws. The attribute encodes:

| Bit field | Value | Meaning |
|-----------|-------|---------|
| ink (bits 0-2) | 1 | blue |
| paper (bits 3-5) | 7 | white |
| bright (bit 6) | 0 | normal |
| flash (bit 7) | 0 | off |

Set pixels (after CPL) appear as **blue** ink; clear pixels as **white**
paper. The game does not store per-picture attribute data — all pictures
use the same blue-on-white scheme.

The `sub_64FB` routine:
1. Clears 88 pixel rows (11 char rows × 8) in the picture area to zero.
2. Fills 11 attribute rows × 10 columns with `$39`.
3. Sets column 11 to `$00` (black border).

### Decompressor

The decompression routine is at `code/8923-89AD_show_name_and_pic.asm`
(`$8923`-`$89AD`). The algorithm:

```
function decompress(compressed_data, screen_writer):
    marker = compressed_data[0]
    src = 1
    while not done:
        b = compressed_data[src]; src += 1
        if b == marker:
            length = compressed_data[src]; src += 1
            value = compressed_data[src]; src += 1
            count = length + 3
            for _ in range(count):
                screen_writer.write(value XOR 0xFF)   # CPL inverts bits
        else:
            screen_writer.write(b XOR 0xFF)
```

Byte 0 of every compressed picture is the **RLE escape marker** — chosen
per-picture to be a value that's rare in the data. When the marker
appears in the bitstream, the next two bytes are length and value;
emit (length+3) copies of value. Otherwise emit the byte directly.

All emitted bytes are XOR'd with `0xFF` (the `cpl` instruction in the
asm) before being written to screen memory. This is the inverse of how
the bytes are stored.

### Screen writer

Picture bytes are not written linearly — they're written into specific
Spectrum screen addresses in a 2-pass interleaved pattern.

The ZX Spectrum screen address format is:

```
Address: 010 TT YYY BBBBB XXXXX
  TT    = third (0-2, each covering 64 pixel rows)
  YYY   = sub-row within character cell (0-7)
  BBBBB = character row within third (0-7)
  XXXXX = byte column (0-31)

pixel_y = TT*64 + BBBBB*8 + YYY
```

The writer uses `simple_down_hl` at `$89B0` which advances the screen
pointer by **one pixel row** (incrementing YYY, with boundary corrections
for character-cell and third boundaries). Called twice per byte write,
this advances by **2 pixel rows** per output byte.

The picture is drawn in **two passes**. Pass 1 writes to even pixel rows
(y = 8, 10, 12, ... 92); pass 2 fills odd rows (y = 9, 11, 13, ... 93).
Each pass writes 10 columns × 43 bytes = 430 bytes (total 860 bytes).

The key control values from the asm:

- Start screen address: `$4021` — byte column 1, pixel row 8
- Bytes per column: 43 (alt B counter wrapping at `$56`)
- Columns per pass: 10 (alt C counter wrapping at `$0A`)
- Passes: 2 (alt B reaching value 2 after pass transition)
- Inter-column reset: HL -= `$0E3F` (rewinds to top of next column)
- Inter-pass reset: HL -= 10, then one `simple_down_hl` (shifts to
  odd rows for pass 2)

Combined coverage: **80 pixels wide × 86 pixel rows** (byte columns 1-10,
pixel rows 8-93).

### Picture pointer table

`___table_58` at `$C288` holds 16-bit little-endian pointers to
compressed picture data. Indexed by pic_id:

```
pointer = word at ($C288 + pic_id * 2)
```

The `show_pic_by_A` routine reads the pointer via two calls to
`GET_B_FROM_TABLE 0Fh`, which walks `ADDR_TABLE[0x0F]` (pointing to
`___table_58 + 1`) using the CPIR-based record scanner at `$7144`.
The +1 offset is undone by the scanner's `dec hl` before reading.

### Picture inventory

20 unique pictures exist in the pointer table (some pic_id values
share the same data pointer):

| ID   | Name            | Address | Used for |
|------|-----------------|---------|----------|
| 0x00 | pic_00          | $AA7B   | Monster portrait |
| 0x01 | pic_01          | $AC22   | Monster portrait |
| 0x02 | PIC_ROSCOES     | $AE5B   | Roscoe's / monster portrait |
| 0x03 | PIC_ZOMBIE      | $B072   | Zombie portrait |
| 0x04 | pic_04          | $B23E   | Monster portrait |
| 0x05 | pic_05          | $B4F9   | Monster portrait |
| 0x06 | pic_06          | $B693   | Monster portrait |
| 0x07 | pic_07          | $B8C8   | Monster portrait |
| 0x08 | pic_08          | $BB04   | Monster portrait |
| 0x0B | pic_0B          | $BCE1   | Monster portrait |
| 0x0D | PIC_GUILD       | $CEF6   | Adventurer's Guild |
| 0x0E | PIC_SHOPPE      | $D0AA   | Garth's Equipment Shoppe |
| 0x0F | PIC_TAVERN      | $D334   | Tavern |
| 0x10 | pic_10          | $E17F   | (unknown location) |
| 0x11 | PIC_TEMPLE      | $D597   | Temple |
| 0x12 | PIC_BUILDING    | $D80F   | Generic empty building |
| 0x13 | PIC_REVIEWBOARD | $D9AD   | Review Board |
| 0x14 | pic_14          | $DBAD   | (unknown location) |
| 0x1A | PIC_GUARDIAN    | $DD6C   | City gate guardians |
| 0x1B | PIC_TOWER       | $DF42   | Towers (Mangar, Kylearan, Castle) |

Duplicate entries in the pointer table (pic_ids that share data):

- 0x09 → same as 0x07 ($B8C8)
- 0x0A → same as 0x05 ($B4F9)
- 0x0C → same as 0x07 ($B8C8)
- 0x18 → same as 0x07 ($B8C8)
- 0x19 → same as 0x07 ($B8C8)

### Monster portrait mapping

Monsters (IDs 0-143) are mapped to one of 13 portrait images via the
`MONST_IMAGE` table at `$8F4E` (`data/8F4E-9272_monsters.asm`). The
lookup chain:

1. Monster ID → `GET_A_FROM_TABLE INX_MONST_IMAGE` (table index `$5A`)
2. Returns an image index 0x00-0x0C from the MONST_IMAGE table
3. Image index used as pic_id for `SHOW_PIC_BY_A`

The 13 unique monster image indices map to picture pointers as follows:

| Image ID | Pointer | Shared with |
|----------|---------|-------------|
| 0x00 | $AA7B | (unique) |
| 0x01 | $AC22 | (unique) |
| 0x02 | $AE5B | also PIC_ROSCOES |
| 0x03 | $B072 | also PIC_ZOMBIE |
| 0x04 | $B23E | (unique) |
| 0x05 | $B4F9 | also pic_0A |
| 0x06 | $B693 | (unique) |
| 0x07 | $B8C8 | also pic_09, 0C, 18, 19 |
| 0x08 | $BB04 | (unique) |
| 0x09 | $B8C8 | same as image 07 |
| 0x0A | $B4F9 | same as image 05 |
| 0x0B | $BCE1 | (unique) |
| 0x0C | $B8C8 | same as image 07 |

So there are **10 unique monster portraits** (images 0x09, 0x0A, and 0x0C
duplicate earlier entries).

## Tooling

`bardstale_imagecodec.py` provides:

- `extract-icons` — render the icon sheet to PNG
- `extract-font` — render the partial font to PNG
- `decompress-pic` — decompress a picture and emit raw output bytes
- `render-pic` — render a single compressed picture to PNG with correct
  Spectrum screen geometry and attribute colours
- `extract-all` — extract all 20 unique pictures from the game binary
  (`original/game_5B00-FFFF.mem`) to a directory as PNG files

### Usage examples

```bash
# Extract all pictures at 3x scale (default)
python docs/bardstale_imagecodec.py extract-all original/game_5B00-FFFF.mem docs/all_pictures

# Extract all at 1:1 native resolution
python docs/bardstale_imagecodec.py extract-all original/game_5B00-FFFF.mem docs/all_pictures --scale 1

# Render a single picture from its .asm source
python docs/bardstale_imagecodec.py render-pic data/some_picture.asm output.png

# Use a custom attribute byte (e.g. cyan ink on black paper)
python docs/bardstale_imagecodec.py extract-all original/game_5B00-FFFF.mem docs/pics --attr 0x05
```
