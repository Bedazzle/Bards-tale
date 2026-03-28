loc_78A8:
		GET_GAME_VARIABLE	VAR_ACTIVE_HERO			; ???

		jr	nc, loc_78B3
		inc	(iy+VAR_66)

loc_78B0:
		jp	print_ellipsis

loc_78B3:
		ld	(iy+VAR_68), b
		inc	b
		jr	nz, loc_78B0

		EXEC_FOR_HEROES	loc_78BF

		jr	loc_78B0

loc_78BF:
		ld	(iy+VAR_4F), 0

		GET_ATTR_BY_PARAM_SAVE_HL	CHAR_NEG_FLAG	; get hero active spell for neg

		ret	z

		ld	a, 2Ah ; '*'

		jp	print_empty
