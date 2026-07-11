# Recursive-descent Z80 disassembler for a Bard's Tale level overlay.
# Models the RST 10h dispatch convention (rst 10h; db id; [params]) using the
# id->param-count map parsed from code/macroses.asm, so disassembly does not
# desync after dispatch calls. Descends the WHOLE overlay from a trusted seed
# set (dispatch table + Ghidra functions), then emits a requested sub-region as
# byte-exact SjASMPlus source (code where reached by flow, db elsewhere).
#
# Usage: python tools/level_disasm.py <level_bin> <ghidra_functions.txt> <out.asm> <emit_lo> <emit_hi>
import sys, re
from z80dis import z80

BIN, FUNCS, OUT, EMIT_LO, EMIT_HI = sys.argv[1], sys.argv[2], sys.argv[3], int(sys.argv[4],16), int(sys.argv[5],16)
BASE=0xC18C
OVL_LO, OVL_HI = 0xC18C, 0xFB50
BLOCK=open(BIN,'rb').read()
def byte(a): return BLOCK[a-BASE]

# --- RST 10h id -> inline param bytes, and id -> macro name, from macroses.asm ---
RST={}; MAC={}
for blk in re.split(r'\bMACRO\b', open("code/macroses.asm",encoding="utf-8",errors="replace").read())[1:]:
    body=blk.split("ENDM")[0]
    if not re.search(r'rst\s+10h',body,re.I): continue
    nm=body.strip().splitlines()[0].split()[0]
    d=re.findall(r'\b(db|dw)\b\s+([^\n;]+)',body,re.I)
    if not d: continue
    try: idn=int(d[0][1].strip().rstrip('h'),16)
    except: continue
    RST[idn]=sum(2 if x[0].lower()=='dw' else 1 for x in d[1:])
    MAC[idn]=nm

# --- seeds: dispatch JP-table targets + JP-table entries + Ghidra functions ---
seeds=[]
for i in range(6):                       # 6 JP vectors at $C18C
    o=i*3
    if byte(0xC18C+o)==0xC3:
        seeds.append(0xC18C+o)
        seeds.append(byte(0xC18C+o+1)|(byte(0xC18C+o+2)<<8))
# Seed from the dispatch table (above) + Ghidra functions, BUT validate each seed:
# large parts of a level ($E6xx+ in the Cellars) are graphics data whose bytes
# ($AA=xor d, $EE=xor n, $2A, $A0/$E0/$C0 ...) decode as valid opcodes, so Ghidra
# marks data as "functions". Reject any seed whose leading bytes are dominated by
# graphics fill values — that keeps real code functions and drops data ones.
GFX=set([0x00,0xFF,0xAA,0x55,0xEE,0xAE,0xEA,0x2A,0xA0,0xE0,0xC0,0x80,0xFE,0x0A,0xA8])
def looks_data(addr):
    if addr+16>OVL_HI: return False
    g=sum(1 for k in range(16) if byte(addr+k) in GFX)
    return g>=9      # >=56% graphics-fill bytes -> data, not code
ghidra=[]
for line in open(FUNCS):
    m=re.search(r'ram:([0-9a-f]{4})',line)
    if m:
        a=int(m.group(1),16)
        if OVL_LO<=a<=OVL_HI and not looks_data(a): ghidra.append(a)
seeds+=ghidra
argv_seeds=[]
for s in sys.argv[6:]:
    try: argv_seeds.append(int(s,16))
    except ValueError: pass
seeds+=argv_seeds
seeds=[s for s in set(seeds) if OVL_LO<=s<=OVL_HI]

# --- recursive descent over the whole overlay (flow only; conflict-free) ---
insns={}; labels=set(); covered=set()
def descend(start_list):
    stack=list(start_list)
    while stack:
        a=stack.pop()
        while True:
            if a<OVL_LO or a>OVL_HI: break
            if a in insns: break
            if a in covered: break            # landed mid-instruction -> stop
            b0=byte(a)
            if b0==0xD7:                        # RST 10h dispatch
                idb=byte(a+1); ln=2+RST.get(idb,0)
                insns[a]=('rst',ln,idb)
                for k in range(ln): covered.add(a+k)
                a+=ln; continue
            ins=z80.decode(BLOCK[a-BASE:a-BASE+4], a)
            ln=ins.len; txt=z80.disasm(ins) if ins else ''
            if not txt or not txt.strip() or ln<1:
                break                            # undecodable -> treat as data, stop path
            insns[a]=('code',ln,txt)
            for k in range(ln): covered.add(a+k)
            mn=txt.split()[0]
            if mn in ('JP','JR','CALL','DJNZ') and '(' not in txt:
                mt=re.search(r'0x([0-9a-fA-F]+)',txt)
                if mt:
                    t=int(mt.group(1),16)
                    if OVL_LO<=t<=OVL_HI: labels.add(t); stack.append(t)
            uncond = txt in ('RET','RETI','RETN') or (mn in ('JP','JR') and ',' not in txt) or txt.startswith('JP (')
            if uncond: break
            a+=ln
descend(seeds)
# argv-provided seeds are usually computed-dispatch/SMC targets — emit labels for them
for s in argv_seeds:
    if s in insns: labels.add(s)
tot=EMIT_HI-EMIT_LO+1
codeb=sum(1 for a in range(EMIT_LO,EMIT_HI+1) if a in covered)
print("overlay descent: %d instrs. emit $%04X-$%04X: %d/%d code bytes"%(len(insns),EMIT_LO,EMIT_HI,codeb,tot))

# --- emit the requested sub-region ---
def cvt(txt):
    s=re.sub(r'0x([0-9a-f]+)', lambda m:'$'+m.group(1), txt.lower())
    p=s.split(' ',1)
    return p[0]+('\t'+p[1] if len(p)>1 else '')
def lbl(a): return "l_%04x"%a

# Pass 1: walk the emit region by instruction length; record the addresses where an
# instruction is actually emitted (authoritative starts) and the data runs.
walk=[]; emitted=set(); a=EMIT_LO
while a<=EMIT_HI:
    if a in insns:
        kind=insns[a]; ln=kind[1]
        walk.append(('i',a,kind)); emitted.add(a); a+=ln
    else:
        run=[]
        while a<=EMIT_HI and a not in insns:
            run.append(a); a+=1
        walk.append(('d',run,None))
# a label is only usable if it is an emitted start inside this region
usable=lambda ti: ti in emitted and EMIT_LO<=ti<=EMIT_HI

# Pass 2: emit, converting control-flow targets to labels only when usable.
out=[]
for kind in walk:
    if kind[0]=='i':
        _,addr,ki=kind
        if addr in labels: out.append("%s:"%lbl(addr))
        if ki[0]=='rst':
            _,ln,idb=ki; np=ln-2; nm=MAC.get(idb)
            if nm and np==0: out.append("\t\t%s"%nm)
            elif nm and np>0: out.append("\t\t%s %s"%(nm, ','.join('$%02x'%byte(addr+2+k) for k in range(np))))
            else: out.append("\t\trst\t$10 : db %s"%(','.join('$%02x'%byte(addr+k) for k in range(1,ln))))
        else:
            s=cvt(ki[2])
            for t in re.findall(r'\$([0-9a-f]+)',s):
                ti=int(t,16)
                if ti in labels and usable(ti): s=s.replace('$'+t,lbl(ti))
            out.append("\t\t"+s)
    else:
        run=kind[1]
        # split data run at any usable label boundary so referenced data labels emit
        i=0
        while i<len(run):
            if run[i] in labels: out.append("%s:"%lbl(run[i]))
            chunk=run[i:i+8]; bs=[byte(x) for x in chunk]
            # don't cross a label mid-chunk
            for j in range(1,len(chunk)):
                if chunk[j] in labels: chunk=chunk[:j]; bs=bs[:j]; break
            asc=''.join(chr(x) if 32<=x<127 else '.' for x in bs)
            out.append("\t\tdb %s\t; %s"%(','.join('$%02x'%x for x in bs),asc))
            i+=len(chunk)

open(OUT,"w",newline="\r\n").write("\n".join(out)+"\n")
print("wrote",OUT,"(%d lines)"%len(out))
