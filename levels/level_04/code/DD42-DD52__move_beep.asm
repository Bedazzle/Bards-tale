; --- move_beep ($DD42-$DD52) -------------------------------
; @done
; Conditionally beep on move (guarded by vars $10/$2E).

move_beep:
		GET_GAME_VARIABLE $10
		ret	nz
		GET_GAME_VARIABLE $2E
		ret	nz
		ld	de,2
		ld	hl,1
		jp	call_beeper
