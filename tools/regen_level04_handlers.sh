#!/usr/bin/env bash
# ############################################################################
# WARNING: the levels/level_04/code/ files are now HAND-POLISHED (meaningful
# dot-locals, In/Out headers, inline comments, @done flips). This script
# BOOTSTRAPPED them and is kept as the reproducible-from-binary record, but
# re-running it REVERTS that hand-polish to first-pass. Do not run unless you
# intend to re-bootstrap.
# ############################################################################
# Regenerate the level-04 (Sewers 2) handler split from original/levels/level_04.bin,
# reproducibly: disassemble (RST-aware, seeded) -> rename dispatch + game-vars + confident
# structural matches -> symbolize -> split one-file-per-routine -> verify byte-exact.
# Run from project root.  Handler code = $D354-$DDC6 (process_turn ends jp $62aa @ $DDC6);
# gfx/wall_element_table starts $DDC7.  Seeds derived in levels/level_04/CARVE.md.
set -e
cd "$(dirname "$0")/.."
STAGE="$TEMP/l4_mono.asm"
BTSYM="$TEMP/bt_l4.sym"
: > "$TEMP/empty.funcs"
CODE="levels/level_04/code"

# handler-code recursive-descent seeds (see CARVE.md):
AUTO="D4FD D568 D73E D8D3 D929 DC63 DD97"
EVENT="D40D D419 D429 D433 D451 D456 D45B D460 D473 D48B D4A0"
SMC="D5D3 D5F7 D61B D640 D984 D998 D9AA D9B8 D9C3 D9EF D9F8 DA0D"
# DATA blocks (label-only, NOT descended as code): special_dispatch_table; the chest/trap
# data ($D850 value tables, $D880 mask-ladder+trap-name pointer table+FF-strings read by
# point_ix_to_record); wandering_creature_data ($D911-$D928, join-chance table).
DATA="=D3C7 =D4D1 =D850 =D880 =D911"     # + cell_feature_masks ($D3C7, ADDR_TABLE slot $03)

# 1) disassemble the handler region ($D354-$DDC7 exclusive end) -> staging mono
python tools/level_disasm.py original/levels/level_04.bin "$TEMP/empty.funcs" "$STAGE" \
    D354 DDC6 $AUTO $EVENT $SMC $DATA >/dev/null

# 2) rename the 6 dispatch entry points (slot roles fixed across overlays)
sed -i \
 -e 's/\bl_dc63\b/handle_move_key/g'          -e 's/\bl_d568\b/refresh_dungeon_view/g' \
 -e 's/\bl_dd97\b/process_turn/g'             -e 's/\bl_d929\b/handle_wandering_creature/g' \
 -e 's/\bl_d73e\b/handle_chest/g'             -e 's/\bl_d4fd\b/scan_cells_ahead/g' \
 "$STAGE"
#    -- confident structural matches (call-set similarity vs level_03, see git log)
sed -i \
 -e 's/\bl_d419\b/ev_spin_facing/g'           -e 's/\bl_d573\b/redraw_location/g' \
 -e 's/\bl_d8d3\b/trap_area_damage/g'         -e 's/\bl_d9d5\b/prompt_pick_hero/g' \
 -e 's/\bl_da19\b/damage_group_checked/g'     -e 's/\bl_da7a\b/announce_stairs/g' \
 -e 's/\bl_dd42\b/move_beep/g' \
 "$STAGE"
#    -- verified against level_03 by behaviour (cell/maze helpers, view/wall renderer
#       hierarchy, wrappers, movement/damage) - read + confirmed 2026-07-13
sed -i \
 -e 's/\bl_d354\b/get_cell_feature/g'         -e 's/\bl_d365\b/process_cell_features/g' \
 -e 's/\bl_d3cd\b/set_state_and_redraw/g'     -e 's/\bl_d460\b/ev_show_number/g' \
 -e 's/\bl_d4a0\b/ev_teleport/g'              -e 's/\bl_d4c0\b/damage_all_groups/g' \
 -e 's/\bl_d535\b/announce_nearby/g'          -e 's/\bl_d5c4\b/maze_cell_addr/g' \
 -e 's/\bl_d5d3\b/render_wall_face0/g'        -e 's/\bl_d5f7\b/render_wall_face1/g' \
 -e 's/\bl_d61b\b/render_wall_face2/g'        -e 's/\bl_d640\b/render_wall_face3/g' \
 -e 's/\bl_d6a0\b/wall_init_face0/g'          -e 's/\bl_d6b0\b/wall_init_face1/g' \
 -e 's/\bl_d6c0\b/wall_init_face2/g'          -e 's/\bl_d6d0\b/wall_init_face3/g' \
 -e 's/\bl_d6e0\b/unpack_cell_walls/g'        -e 's/\bl_d701\b/render_wall_flags/g' \
 -e 's/\bl_d71e\b/wrap_view_we/g' \
 -e 's/\bl_d728\b/wrap_view_ns/g'             -e 's/\bl_d732\b/wrap_maze_coord/g' \
 -e 's/\bl_da49\b/roll_from_daypart_table/g' \
 "$STAGE"
#    -- special-location EVENT handlers (each ends jr event_done) + render/movement
sed -i \
 -e 's/\bl_d429\b/ev_smoke/g'                 -e 's/\bl_d433\b/ev_start_encounter/g' \
 -e 's/\bl_d451\b/ev_damage_all/g'            -e 's/\bl_d456\b/ev_inc_2f/g' \
 -e 's/\bl_d45b\b/ev_inc_3e/g'                -e 's/\bl_d473\b/ev_dispatch_smc/g' \
 -e 's/\bl_d48b\b/ev_set_flags/g' \
 -e 's/\bl_d664\b/get_walls_e/g'              -e 's/\bl_d673\b/get_walls_w/g' \
 -e 's/\bl_d682\b/get_walls_n/g'              -e 's/\bl_d691\b/get_walls_s/g' \
 -e 's/\bl_daa9\b/draw_view_elements/g'       -e 's/\bl_dabd\b/draw_wall_column/g' \
 -e 's/\bl_dbc9\b/draw_wall_element/g'        -e 's/\bl_da38\b/set_damage_state/g' \
 -e 's/\bl_dd53\b/move_party_forward/g'       -e 's/\bl_dd5e\b/step_in_facing/g' \
 "$STAGE"
#    -- cell/dispatch helpers + wandering-creature join + combat helpers
sed -i \
 -e 's/\bl_d3d6\b/mask_cell_byte/g'           -e 's/\bl_d3de\b/dispatch_special_location/g' \
 -e 's/\bl_d984\b/wc_join_scan/g'             -e 's/\bl_d998\b/wc_join_hero/g' \
 -e 's/\bl_d9f8\b/start_combat/g'             -e 's/\bl_da69\b/point_ix_to_record/g' \
 "$STAGE"
#    -- chest/trap + cell-feature DATA blocks (label-only)
sed -i \
 -e 's/\bl_d850\b/trap_value_tables/g'        -e 's/\bl_d880\b/trap_name_table/g' \
 -e 's/\bl_d3c7\b/cell_feature_masks/g' \
 "$STAGE"
#    -- label the 2 in-region data blocks
sed -i -e 's/\bl_d4d1\b/special_dispatch_table/g' -e 's/\bl_d911\b/wandering_creature_data/g' "$STAGE"

# 3) build bt.sym + symbolize shared-engine calls (raw $xxxx -> names)
../_tools/sjasmplus.exe --syntax=abF --msg=err "--sym=$BTSYM" BT_main.asm >/dev/null 2>&1
python tools/level_disasm_symbolize.py "$BTSYM" "$STAGE" "$TEMP/l4_ext_partial.asm" >/dev/null

# 4) rename game-vars ($5Fxx etc -> game_vars.asm names) + revert the ld bc,$8002 constant
python tools/level_gamevars.py "$STAGE"
sed -i 's/\bvar_8002\b/$8002/g' "$STAGE"

# 5) split one-file-per-routine at the real routine entries -> $CODE + include list
python tools/split_level04.py "$STAGE" "$CODE" "$TEMP/l4inc.txt"

# 5b) intra-routine l_XXXX branch labels -> dot-locals (cross-file refs qualified)
python tools/level_dotlocal.py "$CODE"
# 5c) mechanical coding-style pass (byte-safe): $hex -> UPPER + blank after uncond jp/jr/ret
python tools/level_format.py "$CODE"

# 6) regenerate the unified shared externals (union across all carved levels)
python tools/scan_externals.py "$BTSYM" levels/shared_externals.asm \
    "levels/level_02/code/*.asm" "levels/level_02/level_02.asm" \
    "levels/level_03/code/*.asm" "levels/level_03/level_03.asm" \
    "levels/level_04/code/*.asm" "levels/level_04/level_04.asm"

echo "regen done - now build levels/level_04/build_level_04.asm and cmp"
