#!/usr/bin/env bash
# ############################################################################
# WARNING: levels/level_05/code/ becomes HAND-POLISHED after bootstrap. Re-running
# REVERTS the polish. Level 05 (Sewers 3) handler carve, reproducible from binary.
# ############################################################################
# Handler code = $D1F9-$DC6B (process_turn ends jp $62aa @ $DC6B); gfx starts $DC6C.
set -e
cd "$(dirname "$0")/.."
STAGE="$TEMP/l5_mono.asm"; BTSYM="$TEMP/bt_l5.sym"; : > "$TEMP/empty.funcs"
CODE="levels/level_05/code"

SEED="D2B2 D2BE D2CE D2D8 D2F6 D2FB D300 D305 D318 D330 D345 D3A2 D40D D478 D49C D4C0 D4E5 D5E3 D6F5 D705 D725 D7BE D7CE D811 D829 D83D D84F D85D D87A D894 D89D DB08 DC3C"
DATA="=D26C =D37A =D7B6"

# 1) disassemble
python tools/level_disasm.py original/levels/level_05.bin "$TEMP/empty.funcs" "$STAGE" D1F9 DC6B $SEED $DATA >/dev/null
# 2) rename dispatch + data blocks (in mono, before split)
sed -i  -e 's/l_db08/handle_move_key/g'  -e 's/l_d40d/refresh_dungeon_view/g'  -e 's/l_dc3c/process_turn/g'      -e 's/l_d7ce/handle_wandering_creature/g'  -e 's/l_d5e3/handle_chest/g'      -e 's/l_d3a2/scan_cells_ahead/g'  -e 's/l_d26c/cell_feature_masks/g' -e 's/l_d37a/special_dispatch_table/g'  -e 's/l_d7b6/wandering_creature_data/g'  "$STAGE"

# 3) symbolize + game-vars
../_tools/sjasmplus.exe --syntax=abF --msg=err "--sym=$BTSYM" BT_main.asm >/dev/null 2>&1
python tools/level_disasm_symbolize.py "$BTSYM" "$STAGE" "$TEMP/l5_ext.asm" >/dev/null
python tools/level_gamevars.py "$STAGE"
# 4) split + dotlocal + format
python tools/split_level05.py "$STAGE" "$CODE" "$TEMP/l5inc.txt"
python tools/level_apply_names.py "$CODE" "$CODE/.names.json" "$TEMP/l5inc.txt"
python tools/level_dotlocal.py "$CODE"
python tools/level_format.py "$CODE"
# 5) shared externals (union across all levels)
python tools/scan_externals.py "$BTSYM" levels/shared_externals.asm \
  "levels/level_02/code/*.asm" "levels/level_02/level_02.asm" \
  "levels/level_03/code/*.asm" "levels/level_03/level_03.asm" \
  "levels/level_04/code/*.asm" "levels/level_04/level_04.asm" \
  "levels/level_05/code/*.asm" "levels/level_05/level_05.asm"
echo "regen done"
