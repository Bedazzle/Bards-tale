; --- trap_precheck -----------------------------------------
; @done
; When a trap springs: if game vars $10 and $2E are both clear, sound the beeper
; (call_beeper with de=2, hl=1 = pitch/duration). The two vars suppress the sound
; (e.g. silence / already-triggered).
trap_precheck:
		GET_GAME_VARIABLE $10
		ret	nz
		GET_GAME_VARIABLE $2E
		ret	nz
		ld	de,2
		ld	hl,1
		jp	call_beeper
