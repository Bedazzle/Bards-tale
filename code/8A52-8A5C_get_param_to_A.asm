get_param_to_A:
		push	hl
		ld	hl, (GAME_VARIABLES + VAR_CURRENT_PARAM)
		ld	a, (hl)
		inc	hl
		ld	(GAME_VARIABLES + VAR_CURRENT_PARAM), hl
		pop	hl

		ret
