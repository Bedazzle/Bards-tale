; ZX-M8XXX helpers
; @main
; @entry start_interceptor
; @define INTERCEPT
; @define DEBUG_MSG

  	DEVICE ZXSPECTRUM48

	include "ZX_constants.asm"

;TAPFILENAME = "bt.tap"
;BASICNAME EQU "BT"

	;DEFINE KILLERS
	;DEFINE MAXEXPIRIENCE
	;DEFINE MAXGOLD
	;DEFINE MAXLEVEL
	;DEFINE MAXSPLEVEL
	;DEFINE MAXSPPOINTS
	;DEFINE NOCITYMONSTERS

	include	 "tools/TapLib.asm"

	; Define empty macro for sjasmplus.exe compatibility
	MACRO MD5CHECK filename?, hash?
	ENDM

	org 25000
loader:
	ld sp, main_start-1
	ld hl, load_bin
	ld de, SCREEN
	ld bc, loader_end-load_bin
	ldir
	jp SCREEN

load_bin:
	ld ix, main_start
	ld de, main_end-main_start
	ld a, #FF
	scf
	call ROM_LOAD

	ld ix, patcher_start
	ld de, patcher_end-patcher_start
	ld a, #FF
	scf
	call ROM_LOAD

	jp patcher_start
loader_end:


	MakeTape ZXSPECTRUM48, "recompile/bt.tap", "BT", loader, loader_end-loader, loader


	org $5B00
main_start:
	include "BT_game.asm"
main_end:

	SAVETAP "recompile/bt.tap",HEADLESS,main_start,main_end-main_start
	SAVEBIN "recompile/bt.bin",main_start,main_end-main_start
	;LABELSLIST "recompile/labels.l"	; for UnrealSpeccy

	org $FF8E
patcher_start:
	ld sp, $FF00

	ld ix, SCREEN
	ld de, $1B00
	ld a, #FF
	scf
	call ROM_LOAD

	jp	main_start
patcher_end:

	SAVETAP "recompile/bt.tap",HEADLESS,patcher_start,patcher_end-patcher_start

	org $4000
screen_start:
	incbin "original/game_4000-5AFF.mem"	;ok
screen_end:
	SAVETAP "recompile/bt.tap",HEADLESS,screen_start,screen_end-screen_start

	MD5CHECK "recompile/bt.bin", "794fb3c0965f9355dd91b146696742f5"
	MD5CHECK "recompile/bt.tap", "61f836ce2034b5fd4230c34b84bb23c7"

	IFDEF INTERCEPT
		org PARTIAL_FONT
		display "Interceptor:", /A, $

start_interceptor:
		ld hl, run_interceptor
		ld (jmp_main_loop+1), hl
		jp INIT_GAME

run_interceptor:
		include "hack_interceptor.asm"
end_interceptor:

		;SAVESNA "bt_intercept.sna",main_start
		SAVESNA "bt_intercept.sna",start_interceptor
	ENDIF