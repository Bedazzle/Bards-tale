# Split the monolithic level-02 handler disassembly into one file per routine,
# named STARThex-ENDhex__name.asm with a header banner (@done / @wip). Routine
# boundaries = the Ghidra function entries that have a label in the source.
# Usage: python tools/level_disasm_split.py <handlers.asm> <out_code_dir>
import re, os, sys
SRC, OUT = sys.argv[1], sys.argv[2]
lines = open(SRC, encoding="utf-8").read().splitlines()

# addr -> (name, description, done)
R = {
 0xD1D8:("get_cell_feature","Return the MAZE_FEATURES byte for the party's current cell.\n; In:  ($5FAC)=N/S, ($5FAD)=W/E coord.  Out: a = feature byte at cell+$1E4.",True),
 0xD1E9:("apply_cell_to_party","Run the current cell's feature effect over all 6 party members.",False),
 0xD25A:("mask_cell_byte","AND the party's maze wall-plane cell byte with A, storing it back.\n; In:  a = mask.",True),
 0xD344:("proc_D344","??? cell/flag helper; ends with a [type,param,handler] dispatch table.",False),
 0xD381:("scan_cells_ahead","Scan the 3 cells ahead in the facing direction for walls/reveal;\n; sets reveal bits. In: ($5FAE)=facing.",True),
 0xD3B9:("proc_D3B9","??? view helper.",False),
 0xD3EC:("refresh_dungeon_view","Redraw the dungeon location: clear buffers, print location name,\n; reset light state, render the current view.",True),
 0xD3F7:("proc_D3F7","??? view redraw continuation.",False),
 0xD448:("maze_cell_addr","Compute the maze-grid address of a cell: MAZE_WALLS + (row+1)*22 + col.\n; In: c=row, b=col.  Out: hl = cell address, a = (hl).",True),
 0xD5A2:("proc_D5A2","??? small helper.",False),
 0xD5AC:("proc_D5AC","??? small helper.",False),
 0xD5B6:("proc_D5B6","??? small helper.",False),
 0xD5C2:("handle_chest","Chest interaction: show chest picture, print the chest menu\n; (Examine/Open/Disarm/Trap-zap/Leave) and process the chosen action.",True),
 0xD757:("proc_D757","??? special-event helper.",False),
 0xD7AD:("proc_D7AD","??? random value from dungeon table $54 (trap/effect roll?).",False),
 0xD89D:("proc_D89D","??? helper.",False),
 0xD8BC:("proc_D8BC","??? helper.",False),
 0xD8CD:("proc_D8CD","??? helper.",False),
 0xD8FE:("proc_D8FE","??? helper.",False),
 0xD92D:("proc_D92D","??? helper.",False),
 0xDA4D:("proc_DA4D","??? helper.",False),
 0xDAE7:("proc_move_key","Movement/action key handler: read the pressed key and dispatch\n; I/J/K/L (move/turn) and action keys.",True),
 0xDBC6:("proc_DBC6","??? helper.",False),
 0xDBD7:("proc_DBD7","??? helper.",False),
 0xDBE2:("proc_DBE2","??? facing/step helper.",False),
 0xDC1B:("process_turn","End-of-move turn processing: chain event handlers, handle combat,\n; refresh the view.",True),
}
NAME_AT = {a: R[a][0] for a in (0xD1D8,0xD25A,0xD381,0xD3EC,0xD448,0xD5C2,0xDAE7,0xDC1B)}
cur = lambda a: NAME_AT.get(a, "l_%04x" % a)
rename = {cur(a): R[a][0] for a in R}

label_line = {}
for i, ln in enumerate(lines):
    m = re.match(r'^([A-Za-z_][A-Za-z0-9_]*):$', ln)
    if m: label_line[m.group(1)] = i
starts = [a for a in sorted(R) if cur(a) in label_line]      # skip Ghidra funcs with no label
seg = [(a, label_line[cur(a)]) for a in starts]

# remove previously-generated per-routine files
for f in os.listdir(OUT):
    if re.match(r'^[0-9A-F]{4}-[0-9A-F]{4}__', f): os.remove(os.path.join(OUT, f))

files = []
for idx, (a, li) in enumerate(seg):
    end_li = seg[idx+1][1] if idx+1 < len(seg) else len(lines)
    a_end = starts[idx+1]-1 if idx+1 < len(starts) else 0xDC51
    body = lines[li:end_li]
    name, desc, done = R[a]
    body[0] = "%s:" % name
    txt = "\n".join(body)
    for old, new in rename.items():
        if old != name: txt = re.sub(r'\b%s\b' % re.escape(old), new, txt)
    header = ["; --- %s %s" % (name, "-"*max(4, 54-len(name))),
              "; @done" if done else "; @wip"] + ["; " + d for d in desc.split("\n")]
    fname = "%04X-%04X__%s.asm" % (a, a_end, name)
    open(os.path.join(OUT, fname), "w", newline="\r\n").write("\n".join(header)+"\n"+txt+"\n")
    files.append(fname)
os.remove(SRC)
print("split into %d routine files" % len(files))
