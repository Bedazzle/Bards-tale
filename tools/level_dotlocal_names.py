# Rename address-based dot-locals (.dXXX) in the split handler files to role-based
# names derived from control flow: a label targeted by a backward branch (or djnz) is a
# loop (.loop); a forward-only target whose block ends in ret is an exit (.done);
# otherwise a forward skip (.skip). Duplicates within a routine get numeric suffixes.
# Byte-exact (labels only). Updates intra-file refs AND cross-file `owning.dXXX` refs.
# Usage: python tools/level_dotlocal_names.py <code_dir>
import re, os, sys, glob

CODE = sys.argv[1]
files = glob.glob(os.path.join(CODE, "*.asm"))

# owning routine name per file = first global label
def owning(lines):
    for ln in lines:
        m = re.match(r'^([A-Za-z_][A-Za-z0-9_]*):', ln)
        if m:
            return m.group(1)
    return None

BRANCH = re.compile(r'^\s*(jr|jp|djnz|call)\b.*?(\.d[0-9a-f]{3,4})\b')
DEF = re.compile(r'^(\.d[0-9a-f]{3,4}):')
TERM = re.compile(r'^\s*(ret|reti|retn|jp|jr)\b(?!.*,)')  # unconditional terminator

# pass 1: build per-file rename map
global_renames = {}   # (owning, .dXXX) -> .newname
for f in files:
    lines = open(f, encoding='utf-8', newline='').read().replace('\r\n', '\n').split('\n')
    own = owning(lines)
    defs = {}       # .dXXX -> line index
    for i, ln in enumerate(lines):
        m = DEF.match(ln)
        if m:
            defs[m.group(1)] = i
    if not defs:
        continue
    # classify each def
    role = {}
    for lbl, di in defs.items():
        back = False
        fwd = False
        djnz = False
        for i, ln in enumerate(lines):
            m = BRANCH.match(ln)
            if m and m.group(2) == lbl:
                if ln.strip().lower().startswith('djnz'):
                    djnz = True
                if i > di:
                    back = True
                elif i < di:
                    fwd = True
        # block terminator: scan from def to next def/terminator
        ends_ret = False
        for j in range(di + 1, len(lines)):
            if DEF.match(lines[j]):
                break
            if re.match(r'^\s*ret\b', lines[j]):
                ends_ret = True
                break
            if TERM.match(lines[j]):
                break
        if djnz or back:
            role[lbl] = 'loop'
        elif ends_ret:
            role[lbl] = 'done'
        else:
            role[lbl] = 'skip'
    # assign unique names (address order for stable suffixes)
    counts = {}
    for lbl in sorted(defs, key=lambda x: defs[x]):
        r = role[lbl]
        counts[r] = counts.get(r, 0) + 1
        suffix = '' if counts[r] == 1 else str(counts[r])
        global_renames[(own, lbl)] = '.' + r + suffix

# pass 2: apply. intra-file: .dXXX -> .new ; cross-file: owning.dXXX -> owning.new
# build a flat map keyed by owning for intra, and owning-qualified for cross
for f in files:
    raw = open(f, encoding='utf-8', newline='').read()
    nl = '\r\n' if '\r\n' in raw else '\n'
    lines = raw.replace('\r\n', '\n').split('\n')
    own = owning(lines)
    txt = '\n'.join(lines)
    # cross-file qualified refs first (owning2.dXXX)
    for (o2, old), new in global_renames.items():
        txt = re.sub(r'\b' + re.escape(o2) + re.escape(old) + r'\b', o2 + new, txt)
    # intra-file bare refs/defs for THIS file's owning
    for (o2, old), new in global_renames.items():
        if o2 == own:
            txt = re.sub(r'(?<![A-Za-z0-9_.])' + re.escape(old) + r'\b', new, txt)
    open(f, 'w', newline='').write(txt.replace('\n', nl))

print("renamed %d dot-locals across %d files" % (len(global_renames), len(files)))
