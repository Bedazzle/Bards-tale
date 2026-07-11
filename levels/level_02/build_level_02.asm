; The Bard's Tale (ZX Spectrum) — Level 02 (dungeon) standalone overlay build
; ---------------------------------------------------------------------------
; A level block is a 14789-byte ($39C5) overlay that loads at $C18C and covers
; $C18C-$FB50, replacing whichever level was resident (see
; docs/BARDSTALE_LEVEL_FORMAT.md). The shared 3D/combat/spell engine lives BELOW
; $C18C in the permanent main code and is NOT part of this block.
;
; Invoke FROM THE PROJECT ROOT (paths are root-relative, like BT_main.asm):
;   ..\_tools\sjasmplus.exe --syntax=abF --msg=err levels/level_02/build_level_02.asm
; Verify: cmp recompile/level_02.bin original/levels/level_02.bin  (must be identical)

	DEVICE ZXSPECTRUM48

	include "code/macroses.asm"
	include "levels/level_02/level_02_externals.asm"

	org $C18C
level_02_start:
	include "levels/level_02/level_02.asm"
level_02_end:

	ASSERT level_02_end-level_02_start == 14789

	SAVEBIN "recompile/level_02.bin", level_02_start, level_02_end-level_02_start
