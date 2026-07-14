# Level 06 (Catacombs 1) — carve state

Byte-exact region SKELETON done. NEW dungeon TYPE — sprites are Catacombs art (NOT the
Sewers set); levels 6-8 will likely share a catacombs_sprites set (establish when carving gfx).
CRACK TEST negative: reads the same GET slots as Sewers ($03/$17-$1F/$52), none of the mystery
$01/$15/$27/$59/$5B.

## Boundaries (measured, byte-exact)
| region | range |
|---|---|
| front_matter | `$C18C-$C2DF` |
| MESSAGES_TABLE | `$C2E0-$C31F` (DB) |
| MESSAGES_TEXTS | `$C320-$C76D` |
| level_tbl_pad (2B) + tbl_1..6 | `C770/C8F1/CA87/CD1F/CEBD/D083`, end `$D277` |
| handler code | `$D278-$DCEA` (process_turn `$DCBB`, ends jp $62aa @ `$DCEA`) |
| gfx (wall_element_table + sprites) | `$DCEB-$F172` |
| pixel_shift_table | `$F173-$F25C` (tail shifted) |
| maze + tail + special_loc | `$F25D-$FB50` (special_loc `$FA40`) |

Dispatch: `handle_move_key $DB87 · refresh_dungeon_view $D48C · process_turn $DCBB ·
handle_wandering_creature $D84D · handle_chest $D662 · scan_cells_ahead $D421`.

## NEXT (handler carve, via the level_05 pipeline)
Copy regen_level05 -> 06; disassemble `$D278-$DCEA` (EMIT_HI $DCEA), discover event/SMC/data
seeds (iterate to ~12 db-lines like L4/L5), capture addr->name map (.names.json) by structural
match vs the fully-named L4/L5, split + apply_names + dotlocal + format. Then front matter (gen
vs L3 slot template), maze planes DB grids (find MAZE_WALLS base via maze_cell_addr), gfx/sprites
(new Catacombs set), polish. Text shares the generic Sewers/Catacombs messages (stairs/chest/etc).
