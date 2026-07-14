; The Bard's Tale (ZX Spectrum) - Level 06 = CATACOMBS 1 (dungeon) standalone build
; 14789-byte overlay, org $C18C. Invoke from project ROOT. Verify: cmp vs original.
	DEVICE ZXSPECTRUM48
	include "code/macroses.asm"
	include "ZX_constants.asm"
	include "levels/shared_externals.asm"
	include "levels/game_vars.asm"
	org $C18C
level_06_start:
	include "levels/level_06/level_06.asm"
level_06_end:
	ASSERT level_06_end-level_06_start == 14789
	SAVEBIN "recompile/level_06.bin", level_06_start, level_06_end-level_06_start
