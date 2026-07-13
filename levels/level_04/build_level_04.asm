; The Bard's Tale (ZX Spectrum) - Level 04 = SEWERS 2 (dungeon) standalone build
; ---------------------------------------------------------------------------
; 14789-byte overlay, org $C18C. Invoke from project ROOT:
;   ..\_tools\sjasmplus.exe --syntax=abF --msg=err levels/level_04/build_level_04.asm
; Verify: cmp recompile/level_04.bin original/levels/level_04.bin
	DEVICE ZXSPECTRUM48

	include "code/macroses.asm"
	include "ZX_constants.asm"
	include "levels/shared_externals.asm"
	include "levels/game_vars.asm"

	org $C18C
level_04_start:
	include "levels/level_04/level_04.asm"
level_04_end:

	ASSERT level_04_end-level_04_start == 14789
	SAVEBIN "recompile/level_04.bin", level_04_start, level_04_end-level_04_start
