# Rename var_XXXX absolute game-state references in a level mono/handler file to the
# engine's authoritative names from levels/game_vars.asm (addr -> name).
# Usage: python tools/level_gamevars.py <file.asm>
import re, sys
F = sys.argv[1]
m = {}
for ln in open('levels/game_vars.asm', encoding='utf-8'):
    g = re.match(r'\s*([a-z_][a-z0-9_]*)\s+EQU\s+\$([0-9A-Fa-f]+)', ln)
    if g:
        m[int(g.group(2), 16)] = g.group(1)
txt = open(F, encoding='utf-8').read()
for a, nm in m.items():
    txt = re.sub(r'\bvar_%04X\b' % a, nm, txt, flags=re.I)
open(F, 'w', encoding='utf-8', newline='\n').write(txt)
print("renamed %d game-var names" % len(m))
