# Split the level-05 (Sewers 3) handler mono into one file per REAL routine entry,
# named STARThex-ENDhex__name.asm, and emit the ordered include list for the stitcher.
# Real entries = CALL targets + dispatch/ADDR_TABLE/SMC seeds (NOT fall-through jr/jp
# branch labels, which stay as intra-routine locals for the dot-local pass).
# Addresses come straight from the l_XXXX label names (address-encoded) + the known
# dispatch/renamed addresses.  Named routines get @done; still-l_XXXX get @wip.
# Usage: python tools/split_level04.py <mono.asm> <out_code_dir> <includes_out.txt>
import re, os, sys

MONO, OUT, INC = sys.argv[1], sys.argv[2], sys.argv[3]
REGION_START, REGION_END = 0xD1F9, 0xDC6C      # handler code range (exclusive end)

# renamed labels -> address (dispatch + confident structural matches + data blocks)
NAMED_ADDR = {
    'handle_move_key': 0xDB08, 'refresh_dungeon_view': 0xD40D, 'process_turn': 0xDC3C,
    'handle_wandering_creature': 0xD7CE, 'handle_chest': 0xD5E3, 'scan_cells_ahead': 0xD3A2,
    'cell_feature_masks': 0xD26C, 'special_dispatch_table': 0xD37A, 'wandering_creature_data': 0xD7B6,
}
# extra seed entry addresses that must start their own file even if not a CALL target
SEED_ADDR = [0xD2B2, 0xD2BE, 0xD2CE, 0xD2D8, 0xD2F6, 0xD2FB, 0xD300, 0xD305, 0xD318, 0xD330, 0xD345, 0xD3A2, 0xD40D, 0xD478, 0xD49C, 0xD4C0, 0xD4E5, 0xD5E3, 0xD6F5, 0xD705, 0xD725, 0xD7B6, 0xD7BE, 0xD7CE, 0xD811, 0xD829, 0xD83D, 0xD84F, 0xD85D, 0xD87A, 0xD894, 0xD89D, 0xDB08, 0xDC3C]

lines = open(MONO, encoding='utf-8').read().splitlines()
# map current label -> (line index, address)
label_line, label_addr = {}, {}
for i, ln in enumerate(lines):
    m = re.match(r'^([A-Za-z_][A-Za-z0-9_]*):$', ln)
    if not m:
        continue
    lbl = m.group(1)
    label_line[lbl] = i
    if lbl in NAMED_ADDR:
        label_addr[lbl] = NAMED_ADDR[lbl]
    else:
        g = re.match(r'l_([0-9a-f]{4})$', lbl)
        if g:
            label_addr[lbl] = int(g.group(1), 16)

# real routine entries = CALL targets + named + seed addrs (that exist as labels)
txt = '\n'.join(lines)
calltgt = set(re.findall(r'\bcall\s+(?:z,|nz,|c,|nc,)?([A-Za-z_][A-Za-z0-9_]*)', txt))
seed_lbls = {l for l, a in label_addr.items() if a in SEED_ADDR}
entries = set(NAMED_ADDR) | (calltgt & set(label_addr)) | seed_lbls
entries = sorted((label_addr[l], l) for l in entries if l in label_addr)

# clean any prior split files in the handler range
if os.path.isdir(OUT):
    for f in os.listdir(OUT):
        g = re.match(r'^([0-9A-Fa-f]{4})-', f)
        if g and REGION_START <= int(g.group(1), 16) < REGION_END:
            os.remove(os.path.join(OUT, f))
else:
    os.makedirs(OUT)

DATA = {'special_dispatch_table', 'wandering_creature_data'}
inc = []
for k, (a, lbl) in enumerate(entries):
    b = (entries[k + 1][0] - 1) if k + 1 < len(entries) else (REGION_END - 1)
    i0 = label_line[lbl]
    i1 = label_line[entries[k + 1][1]] if k + 1 < len(entries) else len(lines)
    body = lines[i0:i1]
    fn = "%04X-%04X__%s.asm" % (a, b, lbl)
    # First split = all @wip: names are structural-match hypotheses / still-l_XXXX, and
    # nothing is hand-polished yet. Flip to @done per-routine as each is verified+polished
    # (done-marker-honesty: @done means FULLY understood, not just tentatively named).
    hdr = ["; --- %s ($%04X-$%04X) %s" % (lbl, a, b, "-" * max(3, 40 - len(lbl))), "; @wip"]
    open(os.path.join(OUT, fn), "w", newline="\r\n").write("\n".join(hdr + [""] + body) + "\n")
    inc.append('\tinclude "levels/level_05/code/%s"' % fn)

open(INC, "w", newline="\r\n").write("\n".join(inc) + "\n")
print("wrote %d routine files (%d named, %d l_XXXX)" %
      (len(entries), sum(1 for a, l in entries if not l.startswith('l_')),
       sum(1 for a, l in entries if l.startswith('l_'))))
