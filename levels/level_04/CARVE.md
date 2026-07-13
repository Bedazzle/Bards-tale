# Level 04 (Sewers 2) — carve state & groundwork

**FULLY CARVED + POLISHED (byte-exact).** All regions are source/labeled (front matter,
handlers split, wall_element_table DW-of-labels, maze planes DB grids, sprites single-sourced
in levels/sewers_sprites.asm). Handlers: **71 of 73 routines named + @done** with purpose +
In/Out headers (ported from verified level_03 parallels), dot-locals, mechanical formatting.
Only **2 honest @wip**: `l_d9b8` (opaque 6-iteration check_equipped scan) + `l_da0d` (residual
SMC print snippet). Irreducible incbin data (packed text, level_tbl pixels, maze_tail, pixel_shift,
special_loc) = same shared-format @wip residue as levels 1-3. Bootstrap `regen_level04_handlers.sh`
is FROZEN (re-running reverts hand-polish). Remaining vs strict level_03 parity: meaningful
dot-local *names* (.loop/.skip vs the 322 address-based .dXXX) - cosmetic.

--- original groundwork below (historical) ---

## HANDLER SPLIT DONE (byte-exact)
`$D354-$DDC6` split into 68 one-file-per-routine files in `code/` (13 named, 55 `l_XXXX`),
included by `level_04.asm`. All `@wip` (first pass: names are structural-match hypotheses,
nothing polished yet). Reproduced by `tools/regen_level04_handlers.sh` (disasm→rename→
symbolize→gamevars→split→externals; tools `split_level04.py`, `level_gamevars.py`).
Named: 6 dispatch + `ev_spin_facing $D419`, `redraw_location $D573`, `trap_area_damage $D8D3`,
`prompt_pick_hero $D9D5`, `damage_group_checked $DA19`, `announce_stairs $DA7A`,
`move_beep $DD42` + data blocks `special_dispatch_table $D4D1`, `wandering_creature_data $D911`.
**Boundary fix logged:** handler code is `$D354-$DDC6` (process_turn ends `jp $62aa @ $DDC6`),
gfx starts `$DDC7` — NOT `$DDBC` as first sliced; `level_disasm.py` EMIT_HI is *inclusive*.
NEXT: per-routine naming/polish (verify the 13 hypotheses, name the 55 `l_XXXX` via the
structural-match hints + behaviour, dot-localize, In/Out headers, flip `@wip`→`@done` as done).

## NAMING PASS (2026-07-13, byte-exact) — 57 of 69 named
Named+verified against level_03 behaviour (added to `regen_level04_handlers.sh` step 2, so
reproducible): cell/maze helpers (get_cell_feature, process_cell_features, mask_cell_byte,
set_state_and_redraw, maze_cell_addr, dispatch_special_location, point_ix_to_record); the 9
special-location events (ev_smoke/start_encounter/damage_all/inc_2f/inc_3e/dispatch_smc/set_flags
/show_number/teleport + spin_facing); the 3D-view WALL RENDERER hierarchy (draw_view_elements →
draw_wall_column → draw_wall_element; render_wall_face0..3, wall_init_face0..3, get_walls_e/w/n/s,
unpack_cell_walls); wrappers (wrap_view_we/ns, wrap_maze_coord); movement (move_party_forward,
step_in_facing, move_beep); damage (damage_all_groups, damage_group_checked, set_damage_state,
roll_from_daypart_table); wandering-creature join (wc_join_scan, wc_join_hero, start_combat);
+ the 6 dispatch + announce_nearby/announce_stairs/prompt_pick_hero/trap_area_damage/redraw_location.
**12 STILL l_XXXX (honest @wip):** 3 are wandering-creature DATA misdisassembled as code
(l_d850/l_d880/l_d919 - reclassify as =ADDR data like L3's wandering_creature_data), the rest are
small SMC/dispatch fragments + combat helpers (l_d3c7, l_d40d dispatch-loop tail, l_d47e
ev_dispatch_smc SMC tail, l_d6e0 wall-nibble helper, l_d9aa/l_d9b8/l_d9c3/l_d9ef combat helpers,
l_da0d SMC print snippet). NEXT: reclassify the 3 data blocks, name/verify the fragments, then
POLISH (dot-locals, In/Out headers, §3/§13, flip @wip->@done) + level_tbl split + gfx/maze carve.

## Region boundaries (all measured, byte-exact)

| region | range | form |
|---|---|---|
| front_matter (dispatch+ADDR_TABLE+addr_table_2+decoder) | `$C18C-$C2DF` | incbin (carve) |
| MESSAGES_TABLE | `$C2E0-$C31F` | DB ✓ |
| MESSAGES_TEXTS | `$C320-$C801` | incbin |
| level_tbl_pad (14 zero bytes) | `$C802-$C80F` | DB ✓ |
| level_tbl_1..6 | `C810 / C991 / CB27 / CDBF / CF5D / D123`, end `$D353` | incbin |
| handler code | `$D354-$DDBC` | incbin (split next) |
| gfx: wall_element_table + sprites | `$DDBD-$F3FF` | incbin (carve) |
| pixel_shift_table (level-independent, == L3 bytes) | `$F400-$F4E9` | incbin |
| maze planes + maze_tail + special_loc_list | `$F4EA-$FB50` | incbin (carve) |

`addr_table_2` level_tbl sub-indices (same pattern as L3): `$17→C810 $08→C991 $1B→CB27
$06→CDBF $09→CF5D $0B→D123`.

## Handler region ($D354-$DDBC) — disassembly groundwork

Dispatch JP-table roles (fixed across overlays):
`handle_move_key $DC63 · refresh_dungeon_view $D568 · process_turn $DD97 ($DD97-$DDBC,
ends jp $62aa) · handle_wandering_creature $D929 · handle_chest $D73E · scan_cells_ahead $D4FD`.

**Recursive-descent seeds** (for `tools/level_disasm.py ... D354 DDBC`):

- Auto (dispatch + ADDR_TABLE in-overlay code): `D3C7 D4FD D568 D73E D850 D860 D880 D929 DC63 DD97`
- Event handlers (from `dispatch_special_location` @ `l_d3e0`, 4-byte records
  `mask,cell,addrLE` in the table @ `$D4D1`): `D419 D429 D433 D451 D456 D45B D460 D473
  D48B D4A0` plus SMC continuation `D40D`.
- Wall-renderer SMC variants (patched into the `$d5b5` call slot by
  `l_d5a4/l_d5a9/l_d5ae`): `D5D3 D5F7 D61B`; decoding them reveals `D640`.

**DATA blocks inside the code region (label-only `=ADDR`, do NOT descend):**

- `$D4D1-$D4FC` special_dispatch_table (11×4-byte records; read by `ld hl,$d4d1` in
  `dispatch_special_location`).
- `$D911-$D918`(+) wandering_creature_data (small value table; L3 analog was `$D806`).

**STILL TO TRACE (2 small code-as-DB blobs, reached only via SMC — not statically
referenced):** `~$D97C-$D9CB` and `~$D9DD-$D9FF`. Find their SMC entry (patch site
`ld ($slot),hl` / `ld hl,$D9xx`) during the split pass; until then they stay `db` @wip.
With the seeds above the region decodes to ~24 db-lines (data tables + these 2 blobs).

## Next pass (handler split)

1. Re-run `level_disasm.py` with the seed set above → mono.
2. Rename dispatch entries (roles known) + helpers parallel to level_03
   (`maze_cell_addr`, `dispatch_special_location`, `redraw_location`, view/movement
   hierarchy) — verify each by behaviour, don't force names (@done honesty).
3. Assemble standalone (org `$D354`) for addresses → split one-file-per-routine
   into `levels/level_04/code/` → dot-localize → format → scan_externals.
4. Swap the `sewers2_handlers` incbin for the include list; rebuild byte-exact.
