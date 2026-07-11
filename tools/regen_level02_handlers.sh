#!/usr/bin/env bash
# Regenerate the level-02 handler files from original/levels/level_02.bin, reproducibly:
#   disassemble (RST-aware, seeded) -> rename known routines -> symbolize externals
#   -> split one-file-per-routine (headers) -> verify byte-exact.
# Run from the project root.  Seeds = ZX-M8XXX exec map + the $D355 event-dispatch targets.
set -e
cd "$(dirname "$0")/.."
ROOT="$(pwd)"
MONO="levels/level_02/code/D1D8-DC51_cellars_handlers.asm"
SYM="$TEMP/bt_l2.sym"

# exec-map range starts + $D355 dispatch targets
SEEDS=$(python - <<'PY'
import json
em=json.load(open("levels/level_02/EXECMAP.json"))
s=set(int(lo,16) for lo,hi in em.get("exec_ranges",[]) if 0xD1D8<=int(lo,16)<=0xDC51)
s |= {0xD2F7,0xD30F,0xD324,0xD29D,0xD2AD,0xD2D5,0xD2DA,0xD2DF,0xD2E4,0xD2B7}  # $D355 event handlers
print(' '.join('%04X'%a for a in sorted(s)))
PY
)

# 1) disassemble the handler region
python tools/level_disasm.py original/levels/level_02.bin \
    levels/level_02/ghidra_out/functions.txt "$MONO" D1D8 DC51 $SEEDS >/dev/null

# 2) rename the routines we understand (entry label + all refs in the file)
sed -i \
 -e 's/\bl_d1d8\b/get_cell_feature/g'  -e 's/\bl_d25a\b/mask_cell_byte/g' \
 -e 's/\bl_d381\b/scan_cells_ahead/g'  -e 's/\bl_d3ec\b/refresh_dungeon_view/g' \
 -e 's/\bl_d448\b/maze_cell_addr/g'    -e 's/\bl_d5c2\b/handle_chest/g' \
 -e 's/\bl_dae7\b/proc_move_key/g'     -e 's/\bl_dc1b\b/process_turn/g' "$MONO"

# 3) symbolize shared-engine calls via the main-build symbol table
../_tools/sjasmplus.exe --syntax=abF --msg=err "--sym=$SYM" BT_main.asm >/dev/null 2>&1
python tools/level_disasm_symbolize.py "$SYM" "$MONO" levels/level_02/level_02_externals.asm

# 4) split one-file-per-routine (headers, @done/@wip)
python tools/level_disasm_split.py "$MONO" levels/level_02/code

# 5) verify
../_tools/sjasmplus.exe --syntax=abF --msg=err levels/level_02/build_level_02.asm >/dev/null 2>&1
if cmp -s recompile/level_02.bin original/levels/level_02.bin; then echo "BYTE-EXACT"; else echo "MISMATCH"; fi
