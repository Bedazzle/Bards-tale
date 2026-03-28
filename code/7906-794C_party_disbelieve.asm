loc_7906:
		ld	c, 3
		ld	e, 83h

loc_790A:
		GET_C_FROM_TABLE	36h

		jr	z, loc_7932

		GET_C_FROM_TABLE	42h

		jr	z, loc_7932

		GET_GAME_VARIABLE	VAR_68			; ???

		jr	nz, loc_7920

		call	loc_7940
		jr	c, loc_7932

		jr	nz, loc_7932

loc_7920:
		ld	a, 1

		GET_C_FROM_LIST	36h

		ld	(iy+VAR_50), 6
		ld	a, e
		call	loc_7C4E

		PRINT_MESSAGE	29h			; "The party disbelieves..."

		RST_10_29

loc_7932:
		dec	e
		dec	c
		jp	m, loc_790A

		GET_GAME_VARIABLE	VAR_68			; ???

		ret	c

		xor	a
		ld	(GAME_VARIABLES + VAR_68), a

		ret

loc_7940:
		ld	(iy+VAR_ACTIVE_HERO), 80h
		ld	(iy+VAR_53), 1

		RST_10_2A

		ret	c
		or	a

		ret
