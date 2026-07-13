# Render a dungeon level's 3D-view sprites (the wall_element_table's bitmaps) to PNGs
# + a montage, as a visual companion (like the text .decoded.txt). Regenerable.
# Sprite format: header {cols (bytes wide), rows (px tall)} then cols*rows column-major
# bitmap bytes; the wall_element_table = base + $19*e + 5*p, sprite ptr at record+3.
# Usage: python tools/render_level_sprites.py <level>      (e.g. 2 or 3)
import os, sys
from PIL import Image, ImageDraw

BASE = 0xC18C
ROOT = r"C:\Backa\projects\disasms\Bards-tale"

# per-level config: wall_element_table base ($DD5F+$1E form), sprite ptr range, out dir
CFG = {
    2: dict(bin="level_02.bin", tbl=0xDC4B, lo=0xDDDB, hi=0xF2E9, out="level_02"),
    3: dict(bin="level_03.bin", tbl=0xDD7D, lo=0xDF0D, hi=0xF3FF, out="level_03"),
}
lvl = int(sys.argv[1]) if len(sys.argv) > 1 else 2
c = CFG[lvl]
b = open(ROOT + r"\original\levels\%s" % c["bin"], "rb").read()

def by(a):
    i = a - BASE
    return b[i] if 0 <= i < len(b) else 0
def w16(a): return by(a) | (by(a + 1) << 8)

TBL = c["tbl"]
ptrs = sorted(set(w16(TBL + e * 0x19 + p * 5 + 3)
                  for e in range(16) for p in range(5)
                  if c["lo"] <= w16(TBL + e * 0x19 + p * 5 + 3) <= c["hi"]))
ptrs2 = ptrs + [c["hi"] + 1]
outdir = ROOT + r"\levels\%s\gfx" % c["out"]
os.makedirs(outdir, exist_ok=True)

def render(a, size):
    col = by(a); rows = by(a + 1)
    if col == 0 or rows == 0 or col > 16 or rows > 96:
        col = 1; rows = min(size - 2, 96)
    data = [by(a + 2 + k) for k in range(size - 2)]
    img = Image.new("RGB", (col * 8, rows), (0, 0, 80)); px = img.load()
    for cc in range(col):
        for r in range(rows):
            idx = cc * rows + r
            if idx >= len(data): continue
            v = data[idx]
            for bit in range(8):
                px[cc * 8 + bit, r] = (230, 230, 230) if v & (0x80 >> bit) else (20, 20, 50)
    return img, col, rows

thumbs = []
for i, a in enumerate(ptrs):
    img, col, rows = render(a, ptrs2[i + 1] - a)
    img.save(outdir + r"\sprite_%04X.png" % a)
    thumbs.append((a, img, col, rows))

PAD = 6; SC = 2
maxw = max(t[1].width for t in thumbs); maxh = max(t[1].height for t in thumbs)
cols = 8; rowsN = (len(thumbs) + cols - 1) // cols
cellw = maxw * SC + PAD * 2 + 40; cellh = maxh * SC + PAD * 2 + 18
M = Image.new("RGB", (cols * cellw, rowsN * cellh), (35, 35, 45))
d = ImageDraw.Draw(M)
for i, (a, img, col, rows) in enumerate(thumbs):
    cx = (i % cols) * cellw + PAD; cy = (i // cols) * cellh + PAD
    M.paste(img.resize((img.width * SC, img.height * SC), Image.NEAREST), (cx, cy + 12))
    d.text((cx, cy), "%04X %dx%d" % (a, col * 8, rows), fill=(200, 200, 120))
M.save(outdir + r"\_montage.png")
print("rendered %d sprites -> levels/%s/gfx/ + _montage.png" % (len(ptrs), c["out"]))
