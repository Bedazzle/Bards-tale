# Replace raw $XXXX operands in a disassembled overlay file with symbolic names from
# the main build's .sym (shared engine below $C18C + game variables), and emit an
# externals-equates file so the standalone overlay build resolves them.
# Usage: python tools/level_disasm_symbolize.py <bt.sym> <handlers.asm> <externals_out.asm>
import re, sys
SYM, F, OUT = sys.argv[1], sys.argv[2], sys.argv[3]
sym = {}
for line in open(SYM):
    m = re.match(r'(\S+):\s+EQU\s+0x0000([0-9A-Fa-f]{4})', line)
    if m: sym.setdefault(int(m.group(2), 16), m.group(1))
src = open(F, encoding="utf-8").read()
ext = {}
for h in set(re.findall(r'\$([0-9A-Fa-f]{4})', src)):
    a = int(h, 16)
    if 0xC18C <= a <= 0xFB50 or a == 0x4000:        # in-overlay / SCREEN: leave
        continue
    nm = sym.get(a) or ("var_%04X" % a if 0x5B00 <= a <= 0xC18B else None)
    if nm: ext[a] = nm
L = ["; --- Level 02 externals -------------------------------------------------",
     "; Entry points + variables in the SHARED game code below $C18C (present in the full",
     "; build; external to this standalone overlay). Names mirror the main build.", ""]
for a in sorted(ext): L.append("%-22s EQU $%04X" % (ext[a], a))
open(OUT, "w", newline="\r\n").write("\n".join(L) + "\n")
src2 = re.sub(r'\$([0-9A-Fa-f]{4})', lambda m: ext.get(int(m.group(1), 16), m.group(0)), src)
open(F, "w", newline="\r\n").write(src2)
print("symbolized: %d externals" % len(ext))
