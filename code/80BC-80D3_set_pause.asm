set_pause:
		call	pause_speed

		jr	set_speed

pause_speed:
		PRINT_MESSAGE	85h			; "<Pausing>"

		inc	(iy+VAR_PAUSE)		; pause ON

		WAIT_KEY_DOWN

		GET_GAME_VARIABLE	VAR_67		; ???

		jr	z, loc_80D0

		PRINT_SPACE_LINE

loc_80D0:
		dec	(iy+VAR_PAUSE)		; pause OFF

		ret
