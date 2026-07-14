; The Bard's Tale (ZX Spectrum) - Level 05 = SEWERS 3 (dungeon) standalone build
; ---------------------------------------------------------------------------
; 14789-byte overlay, org $C18C. Invoke from project ROOT:
;   ..\_tools\sjasmplus.exe --syntax=abF --msg=err levels/level_05/build_level_05.asm
; Verify: cmp recompile/level_05.bin original/levels/level_05.bin
	DEVICE ZXSPECTRUM48

	include "code/macroses.asm"
	include "ZX_constants.asm"
	include "levels/shared_externals.asm"
	include "levels/game_vars.asm"

	org $C18C
level_05_start:
	include "levels/level_05/level_05.asm"
level_05_end:

	ASSERT level_05_end-level_05_start == 14789
	SAVEBIN "recompile/level_05.bin", level_05_start, level_05_end-level_05_start
