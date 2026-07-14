# Apply an address->name map to already-SPLIT handler files: rename l_XXXX labels (+ all
# refs incl qualified owning.local), rename the STARThex-ENDhex__l_XXXX.asm files to the
# meaningful name, and update the stitcher include list. Byte-safe (labels only).
# Usage: python tools/level_apply_names.py <code_dir> <names.json> <stitcher.asm>
import re, sys, json, glob, os
code, js, stitcher = sys.argv[1], sys.argv[2], sys.argv[3]
names = {int(k, 16): v for k, v in json.load(open(js)).items()}      # addr -> name
old2new = {'l_%04x' % a: n for a, n in names.items()}                # l_XXXX -> name
# 1) token-rename labels/refs across all files
for f in glob.glob(os.path.join(code, '*.asm')):
    t = open(f, encoding='utf-8', newline='').read(); o = t
    for old, new in old2new.items():
        t = re.sub(r'\b' + old + r'\b', new, t)
    if t != o:
        open(f, 'w', newline='').write(t)
# 2) rename files whose label part is a renamed l_XXXX
for f in list(glob.glob(os.path.join(code, '*.asm'))):
    b = os.path.basename(f); m = re.match(r'([0-9A-Fa-f]{4}-[0-9A-Fa-f]{4})__(l_[0-9a-f]{4})\.asm', b)
    if m and m.group(2) in old2new:
        os.rename(f, os.path.join(code, '%s__%s.asm' % (m.group(1), old2new[m.group(2)])))
# 3) update the stitcher include list
t = open(stitcher, encoding='utf-8', newline='').read()
for old, new in old2new.items():
    t = re.sub(r'__' + old + r'\.asm', '__%s.asm' % new, t)
open(stitcher, 'w', newline='').write(t)
print("applied %d names to split files" % len(names))
