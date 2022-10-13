show_compass:
		GET_GAME_VARIABLE	VAR_COMPASS_ON

		ret	z

		ld	a, (GAME_VARIABLES + VAR_FACE_DIRECTION)
		add	a, ICON_ARROW_UP

		jp	show_icon_A
