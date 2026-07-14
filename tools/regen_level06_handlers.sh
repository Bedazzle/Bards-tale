#!/usr/bin/env bash
# ############################################################################
# WARNING: levels/level_06/code/ becomes HAND-POLISHED after bootstrap. Re-running
# REVERTS the polish. Level 05 (Catacombs 1) handler carve, reproducible from binary.
# ############################################################################
# Handler code = $D278-$DCEA (process_turn ends jp $62aa @ $DC6B); gfx starts $DC6C.
set -e
cd "$(dirname "$0")/.."
STAGE="$TEMP/l6_mono.asm"; BTSYM="$TEMP/bt_l6.sym"; : > "$TEMP/empty.funcs"
CODE="levels/level_06/code"

SEED="D33D D34D D357 D375 D37A D37F D384 D397 D3AF D3C4 D421 D48C D4F7 D51B D53F D564 D662 D84D D890 D8A8 D8BC D8CE D8DC D8E7 D8F9 D913 D91C DB87 DCBB"
DATA="=D2EB =D3F9 =D835"

# 1) disassemble
python tools/level_disasm.py original/levels/level_06.bin "$TEMP/empty.funcs" "$STAGE" D278 DCEA $SEED $DATA >/dev/null
# 2) rename dispatch + data blocks
sed -i  -e 's/l_db87/handle_move_key/g'   -e 's/l_d48c/refresh_dungeon_view/g'  -e 's/l_dcbb/process_turn/g'       -e 's/l_d84d/handle_wandering_creature/g'  -e 's/l_d662/handle_chest/g'       -e 's/l_d421/scan_cells_ahead/g'  -e 's/l_d2eb/cell_feature_masks/g' -e 's/l_d3f9/special_dispatch_table/g'  -e 's/l_d835/wandering_creature_data/g'  "$STAGE"

# 3) symbolize + game-vars
../_tools/sjasmplus.exe --syntax=abF --msg=err "--sym=$BTSYM" BT_main.asm >/dev/null 2>&1
python tools/level_disasm_symbolize.py "$BTSYM" "$STAGE" "$TEMP/l6_ext.asm" >/dev/null
python tools/level_gamevars.py "$STAGE"
# 4) split + dotlocal + format
python tools/split_level06.py "$STAGE" "$CODE" "$TEMP/l6inc.txt"
python tools/level_apply_names.py "$CODE" "$CODE/.names.json" "$TEMP/l6inc.txt"
python tools/level_dotlocal.py "$CODE"
python tools/level_format.py "$CODE"
# 5) shared externals (union across all levels)
python tools/scan_externals.py "$BTSYM" levels/shared_externals.asm \
  "levels/level_02/code/*.asm" "levels/level_02/level_02.asm" \
  "levels/level_03/code/*.asm" "levels/level_03/level_03.asm" \
  "levels/level_04/code/*.asm" "levels/level_04/level_04.asm" \
  "levels/level_06/code/*.asm" "levels/level_06/level_06.asm"
echo "regen done"
