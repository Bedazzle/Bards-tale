# Level 05 (Sewers 3) — carve state

Byte-exact **region skeleton** done (`level_05.asm`), with sprites 00..43 already
single-sourced (`levels/sewers_sprites.asm`, verified byte-identical to L3/L4). Remaining
passes mirror level_04: handler split/name → front matter → maze planes → wall_element_table.

## Region boundaries (all measured, byte-exact)
| region | range | note |
|---|---|---|
| front_matter | `$C18C-$C2DF` | dispatch + ADDR_TABLE + addr_table_2 + decoder |
| MESSAGES_TABLE | `$C2E0-$C31F` | DB |
| MESSAGES_TEXTS | `$C320-$C6CF` | 944B (short — shifts everything earlier) |
| level_tbl_1..6 | `C6D0 / C851 / C9E7 / CC7F / CE1D / CFE3`, end `$D1F8` | **no pad** |
| handler code | `$D1F9-$DC6B` | process_turn ends `jp $62aa` @ `$DC6B` |
| wall_element_table | `$DC6C-$DDFB` | 400B (DW-of-sprite-labels when carved) |
| sprites 00..43 (SHARED) | `$DDFC-$F097` | == L3/L4; `include sewers_sprites.asm` |
| sprite_44 / tail | `$F098-$F0F3` | level-specific, 92B |
| pixel_shift_table | `$F0F4-$F1DD` | tail SHIFTED (not `$F400`); content == L3's |
| maze planes | `$F1DE-$F5A5` | MAZE_WALLS + MAZE_FEATURES (22×22 ×2) |
| maze_tail | `$F5A6-$FA3F` | |
| special_loc_list | `$FA40-$FB50` | fixed end anchor |

## Dispatch (roles fixed across overlays)
`handle_move_key $DB08 · refresh_dungeon_view $D40D · process_turn $DC3C ·
handle_wandering_creature $D7CE · handle_chest $D5E3 · scan_cells_ahead $D3A2`

## NEXT — handler carve (via the level_04 pipeline)
Copy `tools/regen_level04_handlers.sh` → `regen_level05_handlers.sh`; adapt the seeds
(disassemble `$D1F9-$DC6C`, EMIT_HI inclusive = `$DC6B`), discover event/SMC seeds + data
blocks (iterate to ~0 db-lines like L4: dispatch table, wandering_creature_data, trap
tables, cell_feature_masks, the 4 wall-renderer SMC variants). Then split_level05.py (adapt
NAMED_ADDR for L5 addresses — same slot roles, structural-match to level_03/04), dotlocal,
format, scan_externals. Then front matter (generate from raw words vs L3 slot template),
maze planes DB grids, wall_element_table DW-of-labels, per-routine polish + @done.
Text SHARED with L3/L4 (same Sewers message pool) — headers/quotes port cleanly.
