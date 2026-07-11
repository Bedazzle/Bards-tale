; --- show_compass -----------------------------------------
; @done
; Draw the compass arrow for the party's current facing. Does nothing if
; the compass is disabled (VAR_COMPASS_ON = 0); otherwise selects the
; arrow icon ICON_ARROW_UP + VAR_FACE_DIRECTION and draws it via
; show_icon_A.
; In:  iy = GAME_VARIABLES.
show_compass:
		GET_GAME_VARIABLE	VAR_COMPASS_ON

		ret	z

		ld	a,(GAME_VARIABLES + VAR_FACE_DIRECTION)
		add	a,ICON_ARROW_UP

		jp	show_icon_A
