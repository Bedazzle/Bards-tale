# Mechanical coding-style formatter for the split handler files (byte-safe: only
# touches presentation). Two passes per file:
#   1. §1/§2 - uppercase every $hex operand ($c2d1 -> $C2D1).
#   2. §5   - insert a blank line after an unconditional jp/jr/ret/reti/retn/jp(rr)
#             when the next line is a bare instruction (not already blank/label/comment).
# Usage: python tools/level_format.py <code_dir>
import re, os, sys, glob

CODE = sys.argv[1]
COND = ("z", "nz", "c", "nc", "p", "m", "po", "pe")

def is_label(l):   return bool(re.match(r'^[A-Za-z_.][\w.]*:', l))
def is_comment(l): return l.lstrip().startswith(";")
def is_blank(l):   return l.strip() == ""

def flow_end(l):
    # returns True if this instruction unconditionally ends control flow
    m = re.match(r'^\t+(\w+)(?:\t(.*))?$', l)
    if not m: return False
    mn = m.group(1).lower(); op = (m.group(2) or "").strip()
    if mn in ("ret", "reti", "retn"): return op == ""      # not "ret z"
    if mn in ("jp", "jr"):
        head = op.split(",", 1)[0].strip().lower()
        if head in COND: return False                       # conditional
        return True                                          # jp/jr target, or jp (hl)
    return False

for f in sorted(glob.glob(os.path.join(CODE, "*.asm"))):
    lines = open(f, encoding="latin-1").read().split("\n")
    # pass 1: uppercase $hex
    lines = [re.sub(r'\$([0-9a-fA-F]+)', lambda m: "$" + m.group(1).upper(), l) for l in lines]
    # pass 2: blank line after unconditional flow-enders
    out = []
    for i, l in enumerate(lines):
        out.append(l)
        if flow_end(l):
            nxt = lines[i + 1] if i + 1 < len(lines) else ""
            if not (is_blank(nxt) or is_label(nxt) or is_comment(nxt)):
                out.append("")
    open(f, "w", encoding="latin-1", newline="\r\n").write("\n".join(out))
print("formatted %d files" % len(glob.glob(os.path.join(CODE, "*.asm"))))
