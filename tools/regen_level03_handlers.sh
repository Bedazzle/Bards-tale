#!/usr/bin/env bash
# Regenerate the level-03 (Sewers 1) handler files from original/levels/level_03.bin,
# reproducibly:  disassemble (RST-aware, seeded) -> rename known routines -> symbolize
# externals -> get routine addresses -> split one-file-per-routine -> verify byte-exact.
# Run from the project root. The mono is a STAGING intermediate ($TEMP); the canonical
# form is the split files levels/level_03/code/STARThex-ENDhex__name.asm (included in
# address order by level_03.asm - keep that include list in sync if boundaries change).
#   Seeds = 6 dispatch vectors (auto) + ADDR_TABLE in-overlay code handlers + the
#   special_dispatch_table ($D48B) event handlers (reached only via the SMC jp at $D3C0).
#   NOT seeded (they are DATA tables): $D816 $D836 $D8C7 $D8CF and the level_tbl block.
set -e
cd "$(dirname "$0")/.."
STAGE="$TEMP/l3_mono.asm"
BTSYM="$TEMP/bt_l3.sym"
SYMBUILD="$TEMP/l3_symbuild.asm"
LABELS="$TEMP/l3_labels.sym"
CODE="levels/level_03/code"

CODE_SEEDS="D30A D476 D4B3 D51E D6CF D6F4 D8DF D9CF DA30 DA4D DAA0 DABD DC19 DD4D"
EVENT_SEEDS="D3CF D3DF D3E9 D407 D40C D411 D416 D429 D441 D456"
# DATA blocks embedded in the code region - label them, don't descend them as code:
#   $D37D-$D382 = cell_feature_masks (6 feature-bit masks; ADDR_TABLE slot $03,
#                 read by process_cell_features via GET_B_FROM_TABLE $03).
#   $D806-$D888 = wandering_creature_data (value tables + $D826 bit-mask ladder +
#                 the $D83E record-pointer table read by point_ix_to_record + records $D84E+).
DATA_LABELS="=D37D =D806"

# 1) disassemble the handler region -> staging mono
python tools/level_disasm.py original/levels/level_03.bin /dev/null "$STAGE" D30A DD7C \
    $CODE_SEEDS $EVENT_SEEDS $DATA_LABELS >/dev/null

# 2) rename the routines we understand (entry label + all refs)
#    -- dispatch entry points (slot roles fixed across all overlays)
sed -i \
 -e 's/\bl_dc19\b/handle_move_key/g'            -e 's/\bl_d51e\b/refresh_dungeon_view/g' \
 -e 's/\bl_dd4d\b/process_turn/g'               -e 's/\bl_d8df\b/handle_wandering_creature/g' \
 -e 's/\bl_d6f4\b/handle_chest/g'               -e 's/\bl_d4b3\b/scan_cells_ahead/g' \
 "$STAGE"
#    -- maze/cell helpers (behaviour-proven, parallel to the named level_02 routines)
sed -i \
 -e 's/\bl_d57a\b/maze_cell_addr/g'             -e 's/\bl_d30a\b/get_cell_feature/g' \
 -e 's/\bl_d38c\b/mask_cell_byte/g'             -e 's/\bl_da1f\b/point_ix_to_record/g' \
 -e 's/\bl_d6e8\b/wrap_maze_coord/g'            -e 's/\bl_d6de\b/wrap_view_ns/g' \
 -e 's/\bl_d6d4\b/wrap_view_we/g'               -e 's/\bl_d476\b/damage_all_groups/g' \
 "$STAGE"
#    -- cell-feature scanner + special-location dispatcher + hero prompt
sed -i \
 -e 's/\bl_d31b\b/process_cell_features/g'      -e 's/\bl_d394\b/dispatch_special_location/g' \
 -e 's/\bl_d98b\b/prompt_pick_hero/g' \
 "$STAGE"
#    -- special-location EVENT handlers (special_dispatch_table $D48B; each ends jr event_done)
sed -i \
 -e 's/\bl_d3dc\b/event_done/g'                 -e 's/\bl_d3cf\b/ev_spin_facing/g' \
 -e 's/\bl_d3df\b/ev_smoke/g'                    -e 's/\bl_d3e9\b/ev_start_encounter/g' \
 -e 's/\bl_d407\b/ev_damage_all/g'              -e 's/\bl_d40c\b/ev_inc_2f/g' \
 -e 's/\bl_d411\b/ev_inc_3e/g'                   -e 's/\bl_d429\b/ev_dispatch_smc/g' \
 -e 's/\bl_d441\b/ev_set_flags/g'                -e 's/\bl_d456\b/ev_teleport/g' \
 "$STAGE"
#    -- view/render + movement helpers (behaviour-proven)
sed -i \
 -e 's/\bl_d529\b/redraw_location/g'            -e 's/\bl_d4eb\b/announce_nearby/g' \
 -e 's/\bl_da30\b/announce_stairs/g'            -e 's/\bl_dd14\b/step_in_facing/g' \
 -e 's/\bl_db7f\b/draw_wall_element/g'          -e 's/\bl_dcf8\b/move_beep/g' \
 -e 's/\bl_d383\b/set_state_and_redraw/g' \
 "$STAGE"
#    -- 3D-view renderer hierarchy + movement
sed -i \
 -e 's/\bl_da5f\b/draw_view_elements/g'         -e 's/\bl_da73\b/draw_wall_column/g' \
 -e 's/\bl_dd09\b/move_party_forward/g'         -e 's/\bl_d9ff\b/roll_from_daypart_table/g' \
 "$STAGE"
#    -- the last 6 identified routine entries + the two embedded DATA blocks
sed -i \
 -e 's/\bl_d806\b/wandering_creature_data/g'    -e 's/\bl_d37d\b/cell_feature_masks/g' \
 -e 's/\bl_d416\b/ev_show_number/g'             -e 's/\bl_d889\b/trap_area_damage/g' \
 -e 's/\bl_d9cf\b/damage_group_checked/g'       -e 's/\bl_d9ee\b/set_damage_state/g' \
 -e 's/\bl_dabd\b/draw_wall_faces/g' \
 "$STAGE"
#    -- in-overlay refs to labelled data blocks (decoder / element table / maze)
sed -i \
 -e 's/\$c2d1/print_sewers_flag1/g' \
 -e 's/ld\thl,\$dd5f/ld\thl,wall_element_table-$1e/' \
 -e 's/ld\thl,\$f4ea/ld\thl,MAZE_WALLS/' \
 "$STAGE"

# 3) symbolize shared-engine calls in the handler mono (raw $xxxx -> names; the
#    externals file it writes here is superseded by scan_externals in step 5c).
../_tools/sjasmplus.exe --syntax=abF --msg=err "--sym=$BTSYM" BT_main.asm >/dev/null 2>&1
python tools/level_disasm_symbolize.py "$BTSYM" "$STAGE" "$TEMP/l3_ext_partial.asm" >/dev/null

# 4) assemble the staging mono standalone (org $D30A) to get each routine's address
cat > "$SYMBUILD" <<EOF
	DEVICE ZXSPECTRUM48
	include "code/macroses.asm"
	include "levels/level_03/level_03_externals.asm"
print_sewers_flag1 EQU \$C2D1		; front-matter decoder entry the handlers call
wall_element_table EQU \$DD7D		; gfx-region labels the handlers reference
MAZE_WALLS         EQU \$F4EA
	org \$D30A
	include "$STAGE"
EOF
../_tools/sjasmplus.exe --syntax=abF --msg=err "--sym=$LABELS" "$SYMBUILD" >/dev/null 2>&1

# 5) split into one-file-per-routine (headers, @wip)
python tools/split_level03.py "$STAGE" "$LABELS" "$CODE" /dev/null >/dev/null

# 5b) convert intra-routine l_XXXX branch labels to dot-locals (cross-file refs qualified)
python tools/level_dotlocal.py "$CODE"

# 5c) regenerate the COMPLETE externals (handler code + the front-matter ADDR_TABLE/decoder)
python tools/scan_externals.py "$BTSYM" levels/level_03/level_03_externals.asm \
    "levels/level_03/code/*.asm" "levels/level_03/level_03.asm"

# 6) verify (the stitcher includes the split files in address order)
../_tools/sjasmplus.exe --syntax=abF --msg=err levels/level_03/build_level_03.asm >/dev/null 2>&1
if cmp -s recompile/level_03.bin original/levels/level_03.bin; then echo "BYTE-EXACT"; else echo "MISMATCH"; fi
