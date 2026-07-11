# Level 02 (Cellars) — data blocks

Every `.bin` in this directory is a byte-exact slice of `original/levels/level_02.bin`
(overlay load address `$C18C`). Filenames are `STARThex-ENDhex__name.bin` (inclusive
range, overlay addresses). The stitcher `levels/level_02/level_02.asm` `incbin`s each at
its labelled address; the rebuild is verified byte-identical (`recompile/level_02.bin`).

| file | range | size | label | consumed by |
|------|-------|-----:|-------|-------------|
| `C320-C6CF__messages_texts.bin` | `$C320-$C6CF` | 944 | `MESSAGES_TEXTS` | `print_msg_cellars` (5-bit text decoder) |
| `C6D0-C850__level_tbl_1.bin` | `$C6D0-$C850` | 385 | `level_tbl_1` | 3D renderer, `ADDR_TABLE` slot `$8D` |
| `C851-C9E6__level_tbl_2.bin` | `$C851-$C9E6` | 406 | `level_tbl_2` | 3D renderer, `ADDR_TABLE` slot `$7E` |
| `C9E7-CC7E__level_tbl_3.bin` | `$C9E7-$CC7E` | 664 | `level_tbl_3` | 3D renderer, `ADDR_TABLE` slot `$91` |
| `CC7F-CE1C__level_tbl_4.bin` | `$CC7F-$CE1C` | 414 | `level_tbl_4` | 3D renderer, `ADDR_TABLE` slot `$7C` |
| `CE1D-CFE2__level_tbl_5.bin` | `$CE1D-$CFE2` | 454 | `level_tbl_5` | 3D renderer, `ADDR_TABLE` slot `$7F` |
| `CFE3-D1D7__level_tbl_6.bin` | `$CFE3-$D1D7` | 501 | `level_tbl_6` | 3D renderer, `ADDR_TABLE` slot `$81` |
| `F6B2-FA3F__cellars_data_tail.bin` | `$F6B2-$FA3F` | 910 | `cellars_data_tail` | maze-plane trailer (mostly zero pad) |
| `FA40-FB50__special_loc_list.bin` | `$FA40-$FB50` | 273 | `special_loc_list` | `dispatch_special_location` |

## `MESSAGES_TEXTS` (`$C320-$C6CF`)

5-bit packed message bitstream for the Cellars' room/event text. Decoded by
`print_msg_cellars` (a per-level clone of the engine text decoder); `MESSAGES_TABLE`
(`$C2E0`, inline in the stitcher) holds the per-message 5-bit-code lengths, and the
decoder walks the bitstream sequentially. **Human-readable companion:**
`C320-C6CF__messages_texts.decoded.txt` (regenerate with `docs/bardstale_textcodec.py`).
Kept as `.bin` because it is a packed bitstream, not byte-addressable records.

## `level_tbl_1` .. `level_tbl_6` (`$C6D0-$D1D7`)

Six per-level lookup tables read by the 3D dungeon-view renderer. Each is the target of
one `ADDR_TABLE` sub-table slot (`addr_table_2`), listed above. **They are reached via
`GET_*_FROM_LIST`, not `GET_*_FROM_TABLE`** — the `_LIST` macros (`RST 10h; DB $1B; DB idx`)
dispatch through `addr_table_2`, whereas `_TABLE` (`DB $3A`) uses the main `ADDR_TABLE`.
`render_wall_face0..3` (`maze_cell_addr`, `$D448`) walk five depth steps and per step do
`GET_B_FROM_TABLE $17/$18` (main table → the `SPELL_REVEAL_STATE`/`SPELL_LIGHT_STATE` per-cell
flags = "is this wall face revealed / lit?") gated with `GET_B_FROM_LIST $1a/$1b` (→
`addr_table_2[$1a]`=`___table_55`, `addr_table_2[$1b]`=`level_tbl_3`, etc.) to fetch the
wall-face pattern byte. So each `level_tbl_N` is the wall-face pattern data for one
facing/depth slot, indexed by depth step (0-4).

**Dynamically confirmed (2026-07-11, `tools/m8xxx/dungeon_trace.html`):** overlaying the
Cellars at `$C18C` and walking with the darkness var (`$5FEB`) cleared fires exactly slots
`$17/$18/$19/$1a/$1b` with sub-indices `0..4` — i.e. the wall renderer reading the SPELL
reveal/light state and the `level_tbl`/`___table_55` wall-pattern data across the 5 depth
steps. NOTE `render_dungeon_view` **skips the walls entirely when the darkness var is set**,
so `level_tbl` is only read when the party has a light spell active (or the var is cleared).

**What they are:** the *level-specific* fill for renderer slots that the **City (level 1)
leaves as dummies** — in the city these same six slots point at shared placeholders
(`___table_55`, and `$7F` -> `___table_53`), i.e. the city has no dungeon geometry to draw
there. Each dungeon overlay supplies its own tables. The byte vocabulary matches the maze
wall grid (`$55/$54/$50/$07` nibble-pair wall codes) interleaved with `$AA/$88/$08` bitmap
runs, consistent with per-depth / per-direction wall-face pattern data used by
`render_wall_face0..3` / `draw_wall_column`.

**Honest status:** the renderer's *access* to these tables is now understood (the
`GET_*_FROM_LIST` / depth-step / reveal-gated path above, confirmed in the trace). What is
still **not fully reverse-engineered** is the *exact meaning of each pattern byte* — how a
returned `level_tbl` byte maps to the specific wall slices drawn on screen (the
`$55/$54/$50/$07` nibble-pair vocabulary). The tables are labelled, correctly
sliced/relocatable, and their role + indexing are documented; only the per-byte pixel
semantics remain. This is the last analysis gap for level 2.

## `cellars_data_tail` (`$F6B2-$FA3F`)

Trailing data after the maze bit-planes. Predominantly `$00` padding with a few short
tables; no code. Carried as an opaque block.

## `special_loc_list` (`$FA40-$FB50`)

Flat list of 2-byte `{SO_NO, WE_EA}` cell coordinates, partitioned by event type.
`dispatch_special_location` walks it once per `special_dispatch_table` record: for event N
it scans `count` coordinate-pairs starting at `special_loc_list + offset` (both fields
taken from the record), and a pair matching the party's current cell (`iy+1` / `iy+2`)
fires that event's handler (`ev_portal`, `ev_teleport`, `ev_message`, ...). `$FF` pairs are
empty slots — the Cellars is a tutorial level and uses few special cells, so the block is
mostly `$FF`. Kept as `.bin` (mostly-sentinel data); the format and the consuming routine
are fully documented (`code/D262-D343__dispatch_special_location.asm` +
`code/D359-D380__special_dispatch_table.asm`).
