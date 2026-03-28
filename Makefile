SJASMPLUS ?= sjasmplus
ASM_FLAGS = --syntax=abF --msg=err

OUTDIR = recompile
ORIGINAL = original/game_5B00-FFFF.mem

.PHONY: all clean verify

all: $(OUTDIR)/bt.tap verify

$(OUTDIR):
	mkdir -p $(OUTDIR)

$(OUTDIR)/bt.tap: BT_main.asm BT_game.asm constants.asm constants_guild.asm constants_gates.asm code/*.asm data/*.asm tables/*.asm gfx/*.asm levels/city/**/*.asm tools/TapLib.asm | $(OUTDIR)
	$(SJASMPLUS) $(ASM_FLAGS) BT_main.asm

verify: $(OUTDIR)/bt.bin
	python3 tools/py_diff_bin.py $(ORIGINAL) $(OUTDIR)/bt.bin

clean:
	rm -f $(OUTDIR)/bt.tap $(OUTDIR)/bt.bin
