import os
from PIL import Image
BASE=0xC18C
ROOT=r"C:\Backa\projects\disasms\Bards-tale"
b=open(ROOT+r"\original\levels\level_02.bin","rb").read()
def by(a):
    i=a-BASE; return b[i] if 0<=i<len(b) else 0
def w16(a): return by(a)|(by(a+1)<<8)
TBL=0xDC4B
ptrs=sorted(set(w16(TBL+e*0x19+p*5+3) for e in range(16) for p in range(5) if 0xDDDB<=w16(TBL+e*0x19+p*5+3)<=0xF2E9))
ptrs2=ptrs+[0xF200]
outdir=ROOT+r"\levels\level_02\gfx"
os.makedirs(outdir,exist_ok=True)

def render(a, size):
    col=by(a); rows=by(a+1)
    if col==0 or rows==0 or col>16 or rows>96:
        # fall back: treat whole thing as rows of 1 byte
        col=1; rows=min(size-2,96)
    data=[by(a+2+k) for k in range(size-2)]
    W=col*8; H=rows
    img=Image.new("RGB",(W,H),(0,0,80))
    px=img.load()
    for c in range(col):
        for r in range(rows):
            idx=c*rows+r
            if idx>=len(data): continue
            v=data[idx]
            for bit in range(8):
                if v&(0x80>>bit): px[c*8+bit, r]=(230,230,230)
                else: px[c*8+bit, r]=(20,20,50)
    return img,col,rows

# individual PNGs + a montage
thumbs=[]
for i,a in enumerate(ptrs):
    size=ptrs2[i+1]-a
    img,col,rows=render(a,size)
    img.save(outdir+r"\sprite_%04X.png"%a)
    thumbs.append((a,img,col,rows))
# montage: grid, scaled up 2x, padded
PAD=6; SC=2
maxw=max(t[1].width for t in thumbs); maxh=max(t[1].height for t in thumbs)
cols=8; rowsN=(len(thumbs)+cols-1)//cols
cellw=maxw*SC+PAD*2+40; cellh=maxh*SC+PAD*2+18
M=Image.new("RGB",(cols*cellw, rowsN*cellh),(35,35,45))
from PIL import ImageDraw
d=ImageDraw.Draw(M)
for i,(a,img,col,rows) in enumerate(thumbs):
    cx=(i%cols)*cellw+PAD; cy=(i//cols)*cellh+PAD
    big=img.resize((img.width*SC,img.height*SC),Image.NEAREST)
    M.paste(big,(cx,cy+12))
    d.text((cx,cy),"%04X %dx%d"%(a,col*8,rows),fill=(200,200,120))
M.save(outdir+r"\_montage.png")
print("rendered %d sprites -> levels/level_02/gfx/ + _montage.png"%len(ptrs))
