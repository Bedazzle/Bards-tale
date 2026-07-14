# Split the level-06 (Catacombs 1) handler mono into one file per REAL routine entry,
# named STARThex-ENDhex__name.asm, and emit the ordered include list for the stitcher.
# Real entries = CALL targets + dispatch/ADDR_TABLE/SMC seeds (NOT fall-through jr/jp
# branch labels, which stay as intra-routine locals for the dot-local pass).
# Addresses come straight from the l_XXXX label names (address-encoded) + the known
# dispatch/renamed addresses.  Named routines get @done; still-l_XXXX get @wip.
# Usage: python tools/split_level04.py <mono.asm> <out_code_dir> <includes_out.txt>
import re, os, sys

MONO, OUT, INC = sys.argv[1], sys.argv[2], sys.argv[3]
REGION_START, REGION_END = 0xD278, 0xDCEB      # handler code range (exclusive end)

# renamed labels -> address (dispatch + confident structural matches + data blocks)
NAMED_ADDR = {
    'handle_move_key': 0xDB87, 'refresh_dungeon_view': 0xD48C, 'process_turn': 0xDCBB,
    'handle_wandering_creature': 0xD84D, 'handle_chest': 0xD662, 'scan_cells_ahead': 0xD421,
    'cell_feature_masks': 0xD2EB, 'special_dispatch_table': 0xD3F9, 'wandering_creature_data': 0xD835,
}
# extra seed entry addresses that must start their own file even if not a CALL target
SEED_ADDR = [0xD33D, 0xD34D, 0xD357, 0xD375, 0xD37A, 0xD37F, 0xD384, 0xD397, 0xD3AF, 0xD3C4, 0xD4F7, 0xD51B, 0xD53F, 0xD564, 0xD890, 0xD8A8, 0xD8BC, 0xD8CE, 0xD8DC, 0xD8E7, 0xD8F9, 0xD913, 0xD91C]

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
# force an entry at every NAMED_ADDR address even if the mono still has the l_XXXX label
# (names are applied post-split via apply_names) - avoids merges of dispatch/data routines
named_addrs = set(NAMED_ADDR.values())
named_lbls = {l for l, a in label_addr.items() if a in named_addrs}
entries = set(NAMED_ADDR) | named_lbls | (calltgt & set(label_addr)) | seed_lbls
entries = sorted((label_addr[l], l) for l in entries if l in label_addr and l in label_line)

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
    inc.append('\tinclude "levels/level_06/code/%s"' % fn)

open(INC, "w", newline="\r\n").write("\n".join(inc) + "\n")
print("wrote %d routine files (%d named, %d l_XXXX)" %
      (len(entries), sum(1 for a, l in entries if not l.startswith('l_')),
       sum(1 for a, l in entries if l.startswith('l_'))))
