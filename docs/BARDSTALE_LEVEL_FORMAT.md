# Bard's Tale (ZX Spectrum, 1988) — Level / Overlay Format

Reverse-engineered from the tape image (2026-07). Describes how the game's **17
levels** are stored and how each is laid out in memory, so any of the 16 dungeons
can be carved consistently — the way `levels/city/` already was for level 1.

## The 17 levels

The game ships **17 level blocks** on tape (and disk), each **14789 bytes**
(`$39C5`), preceded by a 9-byte custom loader header `[id][b1][b2][20 20 20 20 20 20]`
where `id` = `$01`–`$11`:

All 17 levels are now identified (full table in `levels/LEVEL_INDEX.md`):

| id | Level | Status |
|----|-------|--------|
| 1  | **City of Skara Brae** | Done — `levels/city/` |
| 2  | **The Cellars** (Wine Cellar of the Scarlet Bard) | Carved — `levels/level_02/` (byte-exact; handlers disassembled + dynamically validated) |
| 3–5 | **Sewers** 1–3 | To do |
| 6–8 | **Catacombs** 1–3 | To do |
| 9–11 | **Harkyn's Castle** 1–3 | To do |
| 12 | **Kylearan's Tower** | To do |
| 13–17 | **Mangar's Tower** 1–5 | To do |

Identify a level by decoding its text pool: read the bitstream address from the level's
decoder clone (`ld de,nnnn` before `ld hl,$C2E0` — it varies per level), then decode
lengths `$C2E0`..bitstream + the bitstream with `docs/bardstale_textcodec.py`. Each
dungeon's text names it (e.g. "the wine cellar of the Scarlet Bard", "chambers of Bashar
Kavilor", "Mangar's crypt").

Raw payloads extracted to `original/levels/level_NN.bin` (the byte-exact diff target
for each level). `level_01.bin` matches the existing city disassembly.

Provenance: `.tap` and `.tzx` carry identical level data; `.dsk` wraps each level in a
~426-byte disk install stub but the level data is the same (see the `tape-provenance`
memory).

## The overlay model

Every level loads at **`$C18C`** and occupies **`$C18C`–`$FB50`**, overlaying whatever
level was there before. Consequences:

- The **shared engine** (3D renderer, combat, spell resolution, character/party code,
  the four global text pools, monster/spell/item tables) lives **below `$C18C`** in the
  permanent main code (`$5B00`–`$C18B`) and is **not** part of a level block.
- A level block is almost entirely level-specific: **~94 % of the 14789 bytes differ**
  between any two dungeons; only **~2 %** (the dispatch/decoder "interface" at the top)
  is byte-identical across all levels.
- The main code block already contains **level 1 (city)** baked into its `$C18C`–`$FB50`
  tail; loading a dungeon overlays it.

## Fixed layout at the top of every level block

These structures sit at the same address in every level (this is the ~2 % constant
"interface"), verified against the city disassembly:

| Range | Structure | Notes |
|-------|-----------|-------|
| `$C18C`–`$C19D` | **JP dispatch table** | 6× `jp` — `jmp_to_movement`→`movement`, `DISPATCH_MOVEMENT`→sinister/event handler, + spell hooks. Entry point the engine calls to run this level. |
| `$C19E`–`$C2C1` | **`ADDR_TABLE`** — 117-entry master pointer table (`dw label+1`) | The indirection layer: the shared engine reaches level data by index via `RST 10h` `GET_*_FROM_TABLE`. **97/117 entries are identical in every level** (they point to fixed shared data); the rest locate per-level data. |
| `$C28A`–~`$C2DF` | **Text decoder clone** | Near-duplicate of the master 5-bit decoder. **Read its `ld hl,nnnn` / `ld de,nnnn` for this level's actual pool pointers** — the lengths table is `$C2E0` in every level, but the **bitstream address VARIES per level** (city `$C373`; Cellars `$C320`), because each level has a different number of messages. It then jumps to the shared printer (`$C003`/`$C06A`) below `$C18C`. Its exact offset also shifts per level. |
| `$C2E0`–… | **Text lengths table** | Leading byte + one length (5-bit code count) per message. Ends where the bitstream pointer points (city 147 B / 146 msgs; Cellars 64 B / 63 msgs). Same layout as pool 4 in `BARDSTALE_TEXT_FORMAT.md`. |
| (varies) | **Text bitstream** | Per-level messages, 5-bit packed; address = the decoder's `ld de,nnnn`. Decodes to the level's encounter/room text. Shares the global alphabets below `$C18C`. |

Everything from ~`$CEF5` onward is level-specific **data + handler code**: maps, monster/
encounter tables, special-event scripts, and the dungeon-only structures below.

**Code vs data caveat (important).** A level's handler code sits in the low part of the
overlay (interface `$C28A–$C31F` + the dispatch handlers, e.g. the Cellars' `$D1D8–$DC51`).
The **upper half is graphics** — 3D-view wall textures and monster/sprite bitmaps, dense
`$AA/$EE/$AE/$2A/$A0` fill, interleaved with pointer/spec tables (Cellars: `$DC52–$F2E9`,
0 reachable code bytes). Ghidra auto-analysis **mislabels this graphics data as code**
because the fill bytes decode as valid opcodes (`xor d`, `xor n`, …). When disassembling,
seed only from real control flow (the dispatch table) and *validate* any Ghidra-function
seed against graphics-fill density (`tools/level_disasm.py` does this) — or use a dynamic
execution map (`m8xxx`) to separate code from data authoritatively.

## Per-level data pointers

Almost all per-level data lives at **fixed addresses** with **constant `ADDR_TABLE`
pointers** — the pointer is the same in every level, the bytes it points to differ
(e.g. the map slot). The exceptions — the **6 `ADDR_TABLE` entries that vary between
dungeons** — are the **dungeon-only structures** the city doesn't use:

| ADDR_TABLE idx | City (level 1) | Dungeons point to | Meaning |
|----|----|----|----|
| `$03` | `___table_81` (dummy) | `$D24C`–`$D5E4` | dungeon-only structure |
| `$1E` | dummy | `$D6E5`–`$DA7D` | dungeon-only |
| `$1F` | dummy | `$D705`–`$DA9D` | (`$1E`+32) paired with `$1E` |
| `$52` | dummy | `$D6D5`–`$DA6D` | dungeon-only |
| `$53` | dummy | `$D79E`–`$DB36` | dungeon-only |
| `$54` | dummy | `$D796`–`$DB2E` | (`$53`−8) paired with `$53` |

In the city these all default to `___table_81` (a shared dummy); in dungeons they point
into each block's `$D2xx`–`$DBxx` region. Identifying these six is the crux of the
dungeon-specific reverse engineering (likely: maze wall grid, monster spawn table, special
encounters, stair/portal links).

## Recommended per-level workflow

1. `levels/<name>/` mirroring `levels/city/` (`code/` + `data/`); start named
   `level_02` … and rename to the real dungeon (Sewers L1, Catacombs L2, Mangar's
   Tower, …) once identified from its decoded text.
2. Build each level standalone at `org $C18C`, `savebin`/diff against
   `original/levels/level_NN.bin` (14789 bytes) — same byte-exact discipline as the city.
3. Reuse the city's labels for the fixed interface (`$C18C`–`$C372`); the shared
   `ADDR_TABLE` pointers resolve to the global symbols already named in the main build.
4. Decode the level's text pool first (identifies the dungeon and documents its rooms),
   then carve the map grid and the six `$D2xx` dungeon structures.

## Open items (resolve during per-level disassembly)

- Exact **maze grid encoding** (22×22) and its address/pointer.
- The **six `$D2xx`–`$DBxx` dungeon structures** (wall/monster/special/stairs).
- Exact per-dungeon **text string count** (the 147-byte fixed table assumption needs
  confirming per level for clean identification).
- **id → dungeon name** mapping for levels 2–17.
