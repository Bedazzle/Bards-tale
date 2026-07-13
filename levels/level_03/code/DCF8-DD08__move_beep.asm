; --- move_beep ($DCF8-$DD08) -----------------------------------
; @done
; Conditionally beep on move (guarded by vars $10/$2E).

move_beep:
		GET_GAME_VARIABLE $10		; silent while combat active
		ret	nz
		GET_GAME_VARIABLE $2E		; silent while this flag set
		ret	nz
		ld	de,2			; pitch
		ld	hl,1			; duration
		jp	call_beeper
