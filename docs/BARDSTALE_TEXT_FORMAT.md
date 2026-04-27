# Bard's Tale (ZX Spectrum, 1988) — Text Encoding Format

Reverse-engineered from the disassembly.

## Overview

The game stores all in-game text as streams of **5-bit codes** packed
MSB-first into bytes. Codes 0..28 are letter indices into one of three
29-character alphabets; codes 29..31 are shift codes that select the
active alphabet for subsequent codes.

The same codec is used for **four separate text pools**, each with its
own length table and its own bitstream of packed codes. The decoder
routine is shared (one master routine plus one near-duplicate clone for
the city level).

## The four text pools

| Pool # | Pool name             | Lengths table             | Bitstream table         | Decoder              | Entries |
|--------|-----------------------|---------------------------|-------------------------|----------------------|---------|
| 1      | Main game messages    | `messages_table` `$9B0D`  | `words_table` `$9CDE`   | `print_msg_A` `$C06A`| 135     |
| 2      | Item names            | `INDEX_ITEM_LENGTHS` `$9B95` | `INDEX_ITEM_NAMES` `$A23F` | `print_item_name` `$C03D` | 127     |
| 3      | Monster + race + class + combat-verb names | `INDEX_MONSTER_LENGTHS` `$9C20` | `INDEX_MONSTER_NAMES` `$A5EC` | `print_monster_name` `$C063` | 188 |
| 4      | City of Skara Brae text | `messages_table_2` `$C2E0` | `messages_texts_2` `$C373` | `print_msg_param_2` `$C2C2` | 146 |

Total: **596 strings** across all pools.

The lengths-table layout is identical for all four pools:
- Byte 0: leading byte (unused)
- Bytes 1..N: length (in 5-bit codes) of strings 0..N-1

The bitstream layout is identical for all four pools:
- String N starts at byte offset `sum over i in [0..N-1] of ceil(lengths[i+1] * 5 / 8)`
- Each string is padded with zero bits to the next byte boundary

The shared decoder routine is invoked via `print_msg_no_cp` with `HL` =
lengths-table address and `DE` = bitstream-table address. The city
level (`print_msg_param_2`) is a literal copy of the same logic with
hard-coded pointers to its own pool, which suggests the city was
developed/loaded as a separate overlay.

## Memory map

| Label                    | Address       | Size        |
|--------------------------|---------------|-------------|
| `lower_letters`          | `$9AB7`       | 29 bytes    |
| `upper_letters`          | `$9AD4`       | 29 bytes    |
| `digits_more`            | `$9AF1`       | 28 bytes    |
| `messages_table`         | `$9B0D`       | 136 bytes   |
| `INDEX_ITEM_LENGTHS`     | `$9B95`       | 128 bytes   |
| `INDEX_MONSTER_LENGTHS`  | `$9C20`       | 189 bytes   |
| `words_table`            | `$9CDE`       | 1377 bytes (used) |
| `INDEX_ITEM_NAMES`       | `$A23F`       | 839 bytes   |
| `INDEX_MONSTER_NAMES`    | `$A5EC`       | 6646 bytes (1162 used) |
| `messages_table_2`       | `$C2E0`       | 147 bytes   |
| `messages_texts_2`       | `$C373`       | 2946 bytes  |

`INDEX_ITEM_NAMES` lives inside the same disassembly file as
`words_table` (`data/9CDE-A585_words_table.asm`); the two pools share
allocated address space but are accessed through different table-pointer
pairs at runtime.

`INDEX_MONSTER_NAMES` is allocated 6646 bytes (`$A5EC`-`$BFE1`) but only
the first ~1162 bytes hold real data. The remaining ~5500 bytes are
empty/padding — likely room reserved for additional monsters that were
never added.

## The three alphabets

Each alphabet holds 29 entries (positions 0..28).

```
set 1 (lower):  "abcdefghijklmnopqrstuvwxyz\. "
                 0         1         2
                 0123456789012345678901234567 8
                                              ^
                                              pos 28 = space

set 2 (upper):  "ABCDEFGHIJKLMNOPQRSTUVWXYZ,!\r"
                                              ^
                                              pos 28 = CR (0x0D, newline)

set 3 (digits): "0123456789-#()<[].+!':?> ,**"
                 0         1         2
                 0123456789012345678901234567
                                            ^
                                            pos 27 = '*' (filler/duplicate)
```

Notes:
- `\` at lower-set position 26 is **not a literal backslash** — it is
  the **inflection marker** (see below).
- Multiple sets share certain characters (space, `!`, `.`, `,`, `*`).
  The encoder picks the cheapest representation given current shift
  state.
- Set 3 has only 28 distinct characters; the last position is filler.

## Bit packing

Codes are packed MSB-first into bytes. Code N starts at bit offset
`5 * N` from the start of the string's bitstream. To extract code N:

```
bit_offset = 5 * N
byte_index = bit_offset / 8
bit_in_byte = bit_offset % 8
word16 = (bytes[byte_index] << 8) | bytes[byte_index + 1]
word16 <<= bit_in_byte                   # left-justify the code
code = (word16 >> 11) & 0x1F             # take top 5 bits
```

The Z80 implementation at `$C0BD` does exactly this using the `add hl, hl`
shift-left trick with `djnz` for the bit alignment, then three `srl h`
operations to right-justify the 5-bit code in `H`.

## Shift codes

| Code | Action                                                      | Stickiness |
|------|-------------------------------------------------------------|------------|
| 29   | Switch active alphabet to **set 1** (lowercase)             | Sticky     |
| 30   | Switch active alphabet to **set 2** (uppercase) for **next code only** | One-shot |
| 31   | Switch active alphabet to **set 3** (digits/punct)          | Sticky     |

The asymmetry — only set 2 is one-shot — comes from the asm at `$C0EE`:
restoration only happens if the active set was set 2. This matches
typical English text patterns:

- Mostly lowercase with rare capitals → uppercase one-shot avoids a
  return-shift after every capital
- Numeric/symbolic runs → sticky digits shift avoids re-shifting before
  each digit
- Lowercase runs → no shift codes at all

The decoder tracks the active set in register `B` (values 1, 2, 3 for
the three sets) and uses register `C` to remember the prior set across
the upper one-shot. On shift codes, `C := B` then `B := (code - 0x1D) + 1`.
On letter emission, if `B == 2` then `B := C` (restore).

The active set always starts at **set 1 (lowercase)** at the beginning
of every string — state does not persist across strings.

## Inflection markers

The `\` character (code 26 in the lowercase alphabet) does not produce
a literal backslash in output. It is an **inflection toggle** used
extensively in monster/item names to encode singular/plural and
verb-form alternatives in a single string.

### Mechanism

The print routine maintains a "display flag" in `VAR_DISPLAY_COUNT`. On
encountering a `\`, the routine at `loc_C10F` ($C10F) toggles between
two output modes using register pair `D`/`E`:

- `D`: "currently outputting" flag
- `E`: "inside alternate-form region" flag

Combined with `VAR_DISPLAY_COUNT`, this picks one of two literal
sequences based on context. Typically `VAR_DISPLAY_COUNT == 1` selects
the singular form; > 1 selects the plural.

For pure decoding (without runtime context), the `\` markers are
preserved in the output string so callers can interpret them
themselves.

### Patterns observed in monster names

Three patterns appear in the decoded monster table:

**Simple plural-`s` (most common):**
```
"kobold\\s"    → "kobold"   (singular)  or  "kobolds"   (plural)
"orc\\s"       → "orc"      (singular)  or  "orcs"      (plural)
"skeleton\\s"  → "skeleton" (singular)  or  "skeletons" (plural)
```
Form: `<root>\<plural-suffix>\` where the second `\` is implied at
end-of-string. The `\s` produces nothing for singular, "s" for plural.

**Irregular plural (suffix replacement):**
```
"dwar\f\ves"      → "dwarf" or "dwarves"
"thie\f\ves"      → "thief" or "thieves"
"wol\f\ves"       → "wolf"  or "wolves"
"werewol\f\ves"   → "werewolf" or "werewolves"
"swordsm\an\en"   → "swordsman" or "swordsmen"
"bladesm\an\en"   → "bladesman" or "bladesmen"
"old m\an\en"     → "old man" or "old men"
"eye sp\y\ies"    → "eye spy" or "eye spies"
"mercenar\y\ies"  → "mercenary" or "mercenaries"
"ancient enem\y\ies" → "ancient enemy" or "ancient enemies"
"bandersnatch\\es"   → "bandersnatch" or "bandersnatches"
"lich\\es"           → "lich" or "liches"
```
Form: `<root>\<singular-tail>\<plural-tail>`. The first form is
between the two `\`, the second form is after.

**Ambiguous edge cases:**
```
"warrior\ elite\s elite"  → "warrior elite" or "warriors elite"
"balrog\s\"               → "balrog"  or "balrogs"
```

### Why this is a win

For 100+ monsters with regular plural forms, storing one string with
a 5-bit `\` marker (1 code) plus an `s` (1 code) is dramatically
cheaper than storing two complete strings. The `\` mechanism is a
form of in-band morphological encoding — common in games of this era
where every byte counted.

## Lengths-table layout

```
offset 0:    leading byte (unused)
offset 1:    length of string 0  (in 5-bit codes)
offset 2:    length of string 1
...
offset N+1:  length of string N
```

The leading byte exists because `print_msg_A` increments the table
pointer past the message-id position before reading the length:

```asm
        add  hl, bc          ; HL = lengths_table + msg_id
        ...                  ; offset-computation loop
        pop  hl
        inc  hl              ; HL = lengths_table + msg_id + 1
        ld   e, (hl)         ; E = length of string msg_id
```

## Bitstream-table layout

Strings are concatenated in order, each starting on a byte boundary:

```
offset(N) = sum over i in [0..N-1] of ceil(lengths[i+1] * 5 / 8)
```

Trailing bits in the last byte of each string are padding (zero in the
original, but content is irrelevant — the decoder stops after the
declared code count).

## Decode algorithm

```
function decode(pool_lengths, pool_bitstream, string_id):
    L = pool_lengths[string_id + 1]
    offset = sum of ceil(pool_lengths[i+1] * 5 / 8) for i in 0..string_id-1
    raw = pool_bitstream[offset:]

    output = []
    active_set = 0       # 0=lower (default), 1=upper, 2=digits
    saved_set  = 0

    for i in 0..L-1:
        code = extract 5 bits from raw at bit offset 5*i
        if code < 29:
            ch = alphabets[active_set][code]
            output.append(ch)        # \ markers preserved as-is
            if active_set == 1:
                active_set = saved_set    # upper one-shot revert
        else:
            saved_set = active_set
            active_set = code - 29
    return ''.join(output)
```

A second pass (or runtime decision in the live game) interprets `\`
markers per the inflection-marker section above.

## Encode algorithm

The original encoder is **greedy**. For each character:

```
candidates = [(set, position) for set in alphabets if char in set]
best = candidate with minimum cost where:
    cost = 1 if set == active_set else 2
    tie-break: prefer staying in set, then upper one-shot, then sticky shift
emit the shift codes (if any) plus the letter code
update active_set per the shift's stickiness rule
```

This greedy strategy reproduces the original byte counts exactly. For
the main message pool: 1377 bytes original, 1377 bytes re-encoded.

## Round-trip verification

Decode → encode → decode produces identical strings for all four pools.
For the main messages pool, the re-encoded bitstream is byte-identical
to the original.

## Reference implementation

`bardstale_textcodec.py` provides a complete Python codec covering all
four pools. The `dump-all` subcommand decodes and prints all 596 strings
from the live disassembly.

## Cross-references in disassembly

| File                                                       | Purpose                                  |
|------------------------------------------------------------|------------------------------------------|
| `code/C06A-C10E_print_msg_A.asm`                           | Master decoder (offset compute + decode) |
| `code/C128-C147_print_msg_A_part_2.asm`                    | Buffer flushing                          |
| `code/C148-C171_print_from_buffer.asm`                     | Print buffer to screen                   |
| `code/BFE2-C009_print_routines2.asm`                       | Caller setup for main messages           |
| `BT_game.asm:530-580`                                      | Wrappers: `print_item_name`, `print_monster_name` |
| `BT_game.asm:584-608`                                      | `loc_C10F` — `\` inflection-marker handler |
| `levels/city/code/C2C2-C2DF_print_msg_A_part_3.asm`        | City clone of decoder                    |
| `data/9AB7-9B0C_letters.asm`                               | Three alphabets                          |
| `data/9B0D-9B94_messages_table.asm`                        | Pool 1 lengths                           |
| `data/9B95-9C14_items_lengths.asm`                         | Pool 2 lengths                           |
| `data/9C20-9CDC_words.asm`                                 | Pool 3 lengths                           |
| `data/9CDE-A585_words_table.asm`                           | Pool 1 bitstream + Pool 2 bitstream      |
| `data/A5EC-BFE1_UNKNOWN.asm`                               | Pool 3 bitstream                         |
| `levels/city/data/C2E0-C372_messages_table_2.asm`          | Pool 4 lengths                           |
| `levels/city/data/C373-CEF4_messages_texts_2.asm`          | Pool 4 bitstream                         |

## Open questions

- The exact semantics of the `\` toggle for three-way splits like
  `"warrior\ elite\s elite"` need confirmation by running the live game
  and observing output for various group counts.
- `INDEX_MONSTER_NAMES` has ~5500 unused bytes. Was this reserved for
  expansion, or is it overlap with a different data structure not yet
  identified?
- The leading byte of each lengths table — is it always zero, or does
  it carry meaningful data?
- Several entries in the monster table are zero-length:
  indices 6, 7, 34, 35, 36, 37, 51, 52, 53, 54, 66, 67, 68, 69, 79, 80,
  81, 82. These appear in groups of 4 at regular intervals — likely
  reserved slots in a fixed-size monster-class layout, where some
  classes have fewer monster types than others.
