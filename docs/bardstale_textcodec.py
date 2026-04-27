#!/usr/bin/env python3
"""
Bard's Tale (ZX Spectrum, EA 1988) — text codec.

Reverse-engineered from disassembly at github.com/Bedazzle/Bards-tale.
See BARDSTALE_TEXT_FORMAT.md for the full format specification.

The same 5-bit codec is used for FOUR text pools:

  pool 1 — main messages   (135 strings)
  pool 2 — item names      (127 strings)
  pool 3 — monster names + race/class/combat verbs (188 entries)
  pool 4 — Skara Brae city text (146 strings)

USAGE
-----
  python3 bardstale_textcodec.py dump-all <repo_root>
  python3 bardstale_textcodec.py dump-pool <repo_root> <pool_id>
  python3 bardstale_textcodec.py decode <lengths.bin> <bitstream.bin>
  python3 bardstale_textcodec.py decode-asm <lengths.asm> <bitstream.asm>
  python3 bardstale_textcodec.py encode <plaintext.txt> <out_lengths.bin> <out_bitstream.bin>
  python3 bardstale_textcodec.py roundtrip-test <repo_root>

pool_id is one of: messages, items, monsters, city
"""

from __future__ import annotations
import os
import re
import sys
from typing import List, Tuple

# ---------------------------------------------------------------------------
# Alphabets (29 chars each, set 3 has 28 + filler)
# ---------------------------------------------------------------------------
LOWER  = "abcdefghijklmnopqrstuvwxyz\\. "
UPPER  = "ABCDEFGHIJKLMNOPQRSTUVWXYZ,!\r"
DIGITS = "0123456789-#()<[].+!':?> ,**"
ALPHABETS = (LOWER, UPPER, DIGITS)

assert len(LOWER) == 29 and len(UPPER) == 29 and len(DIGITS) == 28


def _build_char_map() -> dict[str, list[tuple[int, int]]]:
    """Map each character to all (set_idx, position) pairs that produce it."""
    m: dict[str, list[tuple[int, int]]] = {}
    for set_idx, alpha in enumerate(ALPHABETS):
        for pos, ch in enumerate(alpha):
            m.setdefault(ch, []).append((set_idx, pos))
    return m


CHAR_MAP = _build_char_map()


# ---------------------------------------------------------------------------
# Pool definitions — file paths within the disassembly repo
# ---------------------------------------------------------------------------
POOLS = {
    'messages': {
        'name': 'Main game messages',
        'lengths_file': 'data/9B0D-9B94_messages_table.asm',
        'bitstream_file': 'data/9CDE-A585_words_table.asm',
        # bitstream file contains BOTH words_table and INDEX_ITEM_NAMES;
        # split at this label
        'bitstream_split_before': 'INDEX_ITEM_NAMES:',
        'bitstream_part': 'before',  # take the part before the split
    },
    'items': {
        'name': 'Item names',
        'lengths_file': 'data/9B95-9C14_items_lengths.asm',
        'bitstream_file': 'data/9CDE-A585_words_table.asm',
        'bitstream_split_before': 'INDEX_ITEM_NAMES:',
        'bitstream_part': 'after',  # take the part after the split
    },
    'monsters': {
        'name': 'Monster + race + class + combat-verb names',
        'lengths_file': 'data/9C20-9CDC_words.asm',
        'bitstream_file': 'data/A5EC-BFE1_UNKNOWN.asm',
        'bitstream_split_before': None,
        'bitstream_part': None,
    },
    'city': {
        'name': 'Skara Brae city text',
        'lengths_file': 'levels/city/data/C2E0-C372_messages_table_2.asm',
        'bitstream_file': 'levels/city/data/C373-CEF4_messages_texts_2.asm',
        'bitstream_split_before': None,
        'bitstream_part': None,
    },
}


# ---------------------------------------------------------------------------
# ASM table parser
# ---------------------------------------------------------------------------
def _parse_db_bytes_text(text: str) -> list[int]:
    out: list[int] = []
    for line in text.splitlines():
        code = line.split(';')[0]
        if not re.search(r'\bdb\b', code, re.IGNORECASE):
            continue
        code = re.sub(r'^\s*\w*:?\s*db\s*', '', code, flags=re.IGNORECASE)
        for tok in code.split(','):
            tok = tok.strip()
            if not tok:
                continue
            m = re.match(r'^0?([0-9A-Fa-f]+)h$', tok)
            if m:
                out.append(int(m.group(1), 16)); continue
            m = re.match(r'^0[xX]([0-9A-Fa-f]+)$', tok)
            if m:
                out.append(int(m.group(1), 16)); continue
            m = re.match(r'^(\d+)$', tok)
            if m:
                out.append(int(m.group(1))); continue
            s = re.match(r'"((?:\\.|[^"\\])*)"', tok)
            if s:
                raw = s.group(1).encode().decode('unicode_escape')
                out.extend(ord(c) for c in raw)
    return out


def parse_asm_bytes(path: str) -> list[int]:
    with open(path) as f:
        return _parse_db_bytes_text(f.read())


def load_pool(repo_root: str, pool_id: str) -> tuple[list[int], list[int]]:
    """Return (lengths_bytes, bitstream_bytes) for the given pool."""
    if pool_id not in POOLS:
        raise ValueError(f"unknown pool {pool_id!r}; valid: {list(POOLS)}")
    spec = POOLS[pool_id]
    lengths = parse_asm_bytes(os.path.join(repo_root, spec['lengths_file']))
    bs_path = os.path.join(repo_root, spec['bitstream_file'])
    if spec['bitstream_split_before']:
        with open(bs_path) as f:
            text = f.read()
        parts = text.split(spec['bitstream_split_before'], 1)
        chosen = parts[0] if spec['bitstream_part'] == 'before' else parts[1]
        bitstream = _parse_db_bytes_text(chosen)
    else:
        bitstream = parse_asm_bytes(bs_path)
    return lengths, bitstream


# ---------------------------------------------------------------------------
# Bit packing
# ---------------------------------------------------------------------------
def pack_codes(codes: List[int]) -> bytes:
    """Pack a list of 5-bit codes MSB-first into bytes."""
    bitbuf = 0
    nbits = 0
    out = bytearray()
    for c in codes:
        if not 0 <= c < 32:
            raise ValueError(f"code {c} out of 5-bit range")
        bitbuf = (bitbuf << 5) | c
        nbits += 5
        while nbits >= 8:
            nbits -= 8
            out.append((bitbuf >> nbits) & 0xFF)
            bitbuf &= (1 << nbits) - 1
    if nbits:
        out.append((bitbuf << (8 - nbits)) & 0xFF)
    return bytes(out)


def unpack_codes(data: bytes, n_codes: int, start_bit: int = 0) -> List[int]:
    """Extract n_codes 5-bit codes MSB-first starting at start_bit in data."""
    codes = []
    for i in range(n_codes):
        bo = start_bit + i * 5
        bi = bo // 8
        bs = bo % 8
        b1 = data[bi] if bi < len(data) else 0
        b2 = data[bi + 1] if bi + 1 < len(data) else 0
        w = ((b1 << 8) | b2) << bs
        codes.append((w >> 11) & 0x1F)
    return codes


# ---------------------------------------------------------------------------
# Decoder
# ---------------------------------------------------------------------------
def decode_codes(codes: List[int]) -> str:
    """Convert a list of 5-bit codes to plaintext.

    Inflection markers (\\) in the lowercase set are preserved as literal
    backslashes — callers can interpret them per the format spec.
    """
    out: list[str] = []
    active = 0      # 0=lower, 1=upper, 2=digits
    saved = 0
    for c in codes:
        if c < 0x1D:
            ch = ALPHABETS[active][c] if c < len(ALPHABETS[active]) else '?'
            out.append(ch)
            if active == 1:
                active = saved
        else:
            saved = active
            active = c - 0x1D   # 29→0, 30→1, 31→2
    return ''.join(out)


def decode_message(lengths: list[int], bitstream: list[int], msg_id: int) -> str:
    """Decode message #msg_id from a pool."""
    if msg_id + 1 >= len(lengths):
        raise IndexError(f"msg_id {msg_id} out of range (max {len(lengths)-2})")
    offset = sum((lengths[i + 1] * 5 + 7) // 8 for i in range(msg_id))
    L = lengths[msg_id + 1]
    nbytes = (L * 5 + 7) // 8
    raw = bytes(bitstream[offset:offset + nbytes + 1])  # +1 for safe last-byte read
    return decode_codes(unpack_codes(raw, L))


def decode_all(lengths: list[int], bitstream: list[int]) -> list[str]:
    n = len(lengths) - 1
    return [decode_message(lengths, bitstream, i) for i in range(n)]


def expand_inflection(s: str, plural: bool) -> str:
    """Apply the \\-inflection mechanism to a decoded string.

    The format is one of:
      "<root>\\<plural-suffix>"           → root vs root+suffix
      "<root>\\<sing-tail>\\<plur-tail>"  → root+sing-tail vs root+plur-tail

    Single \\: append the suffix only when plural=True.
    Two \\:    use first segment if singular, second if plural.
    """
    parts = s.split('\\')
    if len(parts) == 1:
        return s
    if len(parts) == 2:
        return parts[0] + (parts[1] if plural else '')
    if len(parts) == 3:
        return parts[0] + (parts[2] if plural else parts[1])
    # Higher-order: alternating; not commonly used.
    # Best-effort: take even-indexed parts for singular, odd for plural.
    if plural:
        return ''.join(parts[i] for i in range(len(parts)) if i != 1)
    return ''.join(parts[i] for i in range(len(parts)) if i != 2 if i < 2)


# ---------------------------------------------------------------------------
# Encoder (greedy)
# ---------------------------------------------------------------------------
def encode_string(s: str) -> List[int]:
    """Encode plaintext to 5-bit codes using greedy strategy.

    Backslash characters in input are encoded as code 26 in the lowercase
    set (the inflection marker) — callers wanting a literal backslash in
    output have no other path because the alphabet has no other slot for it.
    """
    codes: list[int] = []
    active = 0  # 0=lower, 1=upper, 2=digits

    def emit_with_state(target_set: int, pos: int, cur_state: int) -> tuple[list[int], int]:
        if target_set == cur_state:
            return ([pos], cur_state)
        if target_set == 1:
            # upper one-shot: 30 then letter; state preserved
            return ([0x1E, pos], cur_state)
        # sticky shift to lower (0) or digits (2)
        shift_code = 0x1D if target_set == 0 else 0x1F
        return ([shift_code, pos], target_set)

    for ch in s:
        if ch not in CHAR_MAP:
            raise ValueError(f"character {ch!r} not in any alphabet")
        candidates = CHAR_MAP[ch]
        best: tuple[int, list[int], int] | None = None
        for set_idx, pos in candidates:
            seq, new_state = emit_with_state(set_idx, pos, active)
            cand = (len(seq), seq, new_state)
            if best is None or cand < best:
                best = cand
        assert best is not None
        _, seq, new_state = best
        codes.extend(seq)
        active = new_state
    return codes


def encode_messages(strings: list[str]) -> tuple[bytes, bytes]:
    """Encode strings → (lengths_bytes, bitstream_bytes)."""
    msgs_lens: list[int] = []
    chunks: list[bytes] = []
    for s in strings:
        codes = encode_string(s)
        if len(codes) > 255:
            raise ValueError(f"string too long: {len(codes)} codes (max 255)")
        msgs_lens.append(len(codes))
        chunks.append(pack_codes(codes))
    return bytes([0] + msgs_lens), b''.join(chunks)


# ---------------------------------------------------------------------------
# CLI
# ---------------------------------------------------------------------------
def cmd_decode_asm(lengths_path: str, bitstream_path: str) -> None:
    L = parse_asm_bytes(lengths_path)
    B = parse_asm_bytes(bitstream_path)
    print(f"# {len(L)-1} strings, {len(B)} bytes in bitstream", file=sys.stderr)
    for i, s in enumerate(decode_all(L, B)):
        print(f"[{i:3d}] {s.replace(chr(13), '\\n')!r}")


def cmd_decode_bin(lengths_path: str, bitstream_path: str) -> None:
    L = list(open(lengths_path, 'rb').read())
    B = list(open(bitstream_path, 'rb').read())
    for i, s in enumerate(decode_all(L, B)):
        print(f"[{i:3d}] {s.replace(chr(13), '\\n')!r}")


def cmd_encode(text_path: str, lengths_out: str, bitstream_out: str) -> None:
    strings = []
    with open(text_path) as f:
        for line in f:
            line = line.rstrip('\n')
            if line.startswith('#'):
                continue
            line = line.replace('\\n', '\r')
            strings.append(line)
    lt, bt = encode_messages(strings)
    open(lengths_out, 'wb').write(lt)
    open(bitstream_out, 'wb').write(bt)
    print(f"wrote {lengths_out}: {len(lt)} bytes ({len(strings)} strings)", file=sys.stderr)
    print(f"wrote {bitstream_out}: {len(bt)} bytes", file=sys.stderr)


def cmd_dump_pool(repo_root: str, pool_id: str) -> None:
    L, B = load_pool(repo_root, pool_id)
    spec = POOLS[pool_id]
    n = len(L) - 1
    print(f"=== Pool {pool_id!r}: {spec['name']} ({n} strings) ===")
    print(f"# lengths file: {spec['lengths_file']} ({len(L)} bytes)")
    print(f"# bitstream file: {spec['bitstream_file']} ({len(B)} bytes)")
    print()
    for i, s in enumerate(decode_all(L, B)):
        disp = s.replace('\r', '\\n')
        print(f"[{i:3d}] L={L[i+1]:3d}: {disp!r}")
    used = sum((L[i+1]*5+7)//8 for i in range(n))
    print(f"\n# bytes used: {used} / {len(B)} available")


def cmd_dump_all(repo_root: str) -> None:
    for pid in POOLS:
        cmd_dump_pool(repo_root, pid)
        print()


def cmd_roundtrip_test(repo_root: str) -> None:
    all_ok = True
    for pid in POOLS:
        L, B = load_pool(repo_root, pid)
        decoded = decode_all(L, B)
        L2, B2 = encode_messages(decoded)
        decoded2 = decode_all(list(L2), list(B2))
        ok = decoded == decoded2
        used = sum((L[i+1]*5+7)//8 for i in range(len(L)-1))
        new = len(B2)
        print(f"pool {pid:10s}: roundtrip={'OK' if ok else 'FAIL'}  "
              f"orig_used={used:5d}  re_encoded={new:5d}")
        if not ok:
            for i, (a, b) in enumerate(zip(decoded, decoded2)):
                if a != b:
                    print(f"  diff at {i}: {a!r} vs {b!r}")
            all_ok = False
    print("\nAll pools OK" if all_ok else "\nFAILURES")


def main() -> int:
    if len(sys.argv) < 2:
        print(__doc__, file=sys.stderr); return 2
    cmd = sys.argv[1]
    args = sys.argv[2:]
    try:
        if cmd == 'decode' and len(args) == 2:
            cmd_decode_bin(*args)
        elif cmd == 'decode-asm' and len(args) == 2:
            cmd_decode_asm(*args)
        elif cmd == 'encode' and len(args) == 3:
            cmd_encode(*args)
        elif cmd == 'dump-pool' and len(args) == 2:
            cmd_dump_pool(*args)
        elif cmd == 'dump-all' and len(args) == 1:
            cmd_dump_all(*args)
        elif cmd == 'roundtrip-test' and len(args) == 1:
            cmd_roundtrip_test(*args)
        else:
            print(__doc__, file=sys.stderr); return 2
    except (OSError, ValueError, IndexError) as e:
        print(f"error: {e}", file=sys.stderr); return 1
    return 0


if __name__ == '__main__':
    sys.exit(main())
