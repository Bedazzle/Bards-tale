; --- move_beep ($DCF8-$DD08) -----------------------------------
; @wip
; Conditionally beep on move (guarded by vars $10/$2e).

move_beep:
		GET_GAME_VARIABLE $10
		ret	nz
		GET_GAME_VARIABLE $2e
		ret	nz
		ld	de,2
		ld	hl,1
		jp	call_beeper
