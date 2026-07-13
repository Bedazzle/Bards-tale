; The Bard's Tale (ZX Spectrum) — Level 03 = SEWERS 1 (dungeon) standalone build
; ---------------------------------------------------------------------------
; A level block is a 14789-byte ($39C5) overlay that loads at $C18C and covers
; $C18C-$FB50, replacing whichever level was resident (see
; docs/BARDSTALE_LEVEL_FORMAT.md). The shared 3D/combat/spell engine lives BELOW
; $C18C in the permanent main code and is NOT part of this block.
;
; Invoke FROM THE PROJECT ROOT (paths are root-relative, like BT_main.asm):
;   ..\_tools\sjasmplus.exe --syntax=abF --msg=err levels/level_03/build_level_03.asm
; Verify: cmp recompile/level_03.bin original/levels/level_03.bin  (must be identical)
;
; STATUS: initial scaffold — the whole overlay is one incbin (black box). It is
; being carved progressively following the level_02 template; regions are peeled
; off into labelled slices as they are understood.

	DEVICE ZXSPECTRUM48

	include "code/macroses.asm"
	include "levels/level_03/level_03_externals.asm"

	org $C18C
level_03_start:
	include "levels/level_03/level_03.asm"
level_03_end:

	ASSERT level_03_end-level_03_start == 14789

	SAVEBIN "recompile/level_03.bin", level_03_start, level_03_end-level_03_start
