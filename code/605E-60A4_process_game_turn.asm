process_game_turn:
		inc	(iy+VAR_12)				; ??? processing day/night cycle flag

param_to_copy:
		ld	hl, GAME_VARIABLES + VAR_45
		ld	bc, 33h					; 51
		ld	de, GAME_PARAM_COPY
		ldir

		ld	hl, sentence			; to sentence_2
		ld	c, 14h					; 20
		ldir

		ld	hl, SOME_BUFF			; to some_buff_copy
		ld	c, 0Ch					; 12
		ldir

		call	process_daynight
		dec	(iy+VAR_12)				; ??? processing day/night cycle flag

		GET_GAME_VARIABLE	VAR_13		; ???

		jr	z, copy_to_param

		ld	(iy+VAR_13), 0

		PRINT_STATS_TABLE

copy_to_param:
		ld	de, GAME_VARIABLES + VAR_45
		ld	hl, GAME_PARAM_COPY
		ld	bc, 33h
		ldir

		ld	de, sentence
		ld	c, 14h
		ldir

		ld	de, SOME_BUFF
		ld	c, 0Ch
		ldir

		ret
