# Convert intra-routine l_XXXX branch labels in the split handler files to SjASMPlus
# dot-locals scoped to their owning routine. The OWNING label of each file (its first
# label = the routine entry) stays global; every other l_XXXX in the file becomes a
# dot-local `.XXXX`. References from OTHER files to such an internal label are rewritten
# as the qualified form `owning.XXXX` (SjASMPlus global.local). Byte-exact (labels only).
# Usage: python tools/level_dotlocal.py <code_dir>
import re, os, sys, glob

CODE = sys.argv[1]
files = sorted(glob.glob(os.path.join(CODE, "*.asm")))

owning = {}       # file -> first (owning) label
label_file = {}   # internal l_XXXX label -> defining file
for f in files:
    first = None
    for ln in open(f, encoding="latin-1"):
        m = re.match(r'^([A-Za-z_][A-Za-z0-9_]*):', ln)
        if not m:
            continue
        lb = m.group(1)
        if first is None:
            first = lb                      # owning routine entry (stays global)
        elif re.match(r'^l_[0-9a-f]{4}$', lb):
            label_file[lb] = f              # internal l_XXXX (-> dot-local)
    owning[f] = first

dot = lambda lbl: "." + lbl[2:]             # l_d320 -> .d320

n_local = n_qual = 0
for f in files:
    txt = open(f, encoding="latin-1").read()
    # 1) this file's own internal labels: definition + local references -> dot-local
    mine = [l for l, ff in label_file.items() if ff == f]
    for lbl in mine:
        txt, c = re.subn(r'\b' + lbl + r'\b', dot(lbl), txt)
        n_local += 1
    # 2) references to OTHER files' internal labels -> qualified owning.local
    def qualify(m):
        global n_qual
        lbl = m.group(0)
        of = label_file.get(lbl)
        if of is not None and of != f:
            n_qual += 1
            return owning[of] + dot(lbl)
        return lbl                          # global routine entry (l_dXXX) -> leave
    txt = re.sub(r'\bl_[0-9a-f]{4}\b', qualify, txt)
    open(f, "w", encoding="latin-1", newline="\r\n").write(txt)

print("dot-localized %d internal labels, %d cross-file refs qualified" % (n_local, n_qual))
