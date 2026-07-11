# Build a v1 .z80 snapshot from the Bard's Tale memory dumps ($4000-$FFFF).
#
# NOTE (important, see README.md): this snapshot is NOT self-sufficiently runnable.
# The game's RST 10h dispatch handler ($0010), IM2 vector table ($2B00) and
# get_param_to_A all live in $0000-$3FFF, which the .mem dumps do NOT contain and
# which stock 48K ROM does not provide. Resuming this snapshot NOP-sleds through
# blank low memory after ~8 bytes. A real execution map needs a FULL snapshot
# (.szx/.z80 with $0000-$FFFF + registers) captured from the running game.
#
# Kept for when such a snapshot exists / for the low-memory-reconstruction route.
import sys
mem = open("original/game_4000-5AFF.mem","rb").read() + open("original/game_5B00-FFFF.mem","rb").read()
assert len(mem)==0xC000
def w16(v): return bytes([v&0xff,(v>>8)&0xff])
PC = int(sys.argv[1],16) if len(sys.argv)>1 else 0x6034   # set_vars_and_IM -> game_cycle
OUT= sys.argv[2] if len(sys.argv)>2 else "recompile/bardstale.z80"
h=bytearray(30)
h[6:8]=w16(PC); h[8:10]=w16(0xFFFF)     # PC, SP
h[10]=0x3F                              # I (game sets I=$2B, IM2 itself)
h[23:25]=w16(0x5FAB)                    # IY = GAME_VARIABLES
h[27]=1; h[28]=1; h[29]=0x02            # IFF1/2 on, IM2
open(OUT,"wb").write(bytes(h)+mem)
print("wrote", OUT, "PC=$%04X"%PC)
