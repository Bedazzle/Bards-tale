oh_dear_game_over:
		ld	a, PIC_ZOMBIE
		ld	b, 93h						; text: Rot In Peace

		SHOW_NAME_PIC_AB

		PRINT_MESSAGE	40h				; "Oh dear! Your gang hath ceased to be..."

		PRINT_STATS_TABLE

		WAIT_KEY_DOWN

		ld	hl, GUILD_COORDS			; TODO: load from level's data
		ld	(GAME_VARIABLES + VAR_COORD_SO_NO), hl
		ld	(iy+VAR_FACE_DIRECTION), FACE_WEST

		GET_GAME_VARIABLE	VAR_UNDERGROUND

		jp	z, game_cycle

		xor	a
		ld	(GAME_VARIABLES + VAR_3B), a
		ld	c, 1
		ld	b, c

		jp	insert_skara_tape
