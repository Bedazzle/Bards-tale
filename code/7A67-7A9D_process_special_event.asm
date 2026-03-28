sub_7A67:
		GET_GAME_VARIABLE	VAR_10			; ???

		ret	z

		inc	(iy+VAR_0F)
		call	loc_7A75
		dec	(iy+VAR_0F)

		ret

loc_7A75:
		call	sub_82D2
		xor	a
		ld	(GAME_VARIABLES + VAR_0E), a
		ld	a, (GAME_VARIABLES + VAR_11)

		cp	4
		jr	z, loc_7A90

		sub	1
		ret	nz

		ld	(GAME_VARIABLES + VAR_LIGHT), a
		ld	(GAME_VARIABLES + VAR_LIGHT_DIST), a

		SHOW_ICON	9

		ret

loc_7A90:
		GET_GAME_VARIABLE	VAR_12			; ???

		jr	z, loc_7A99

		xor	a
		ld	(GAME_PARAM_COPY+12h), a

loc_7A99:
		ld	b, 0

		jp	loc_74BA
