loc_7DF9:
		inc	(iy+VAR_PAUSE)		; pause ON
		ld	c, 6

loc_7DFE:
		ld	b, c

		FIND_HERO_BY_B

		CHECK_EQUIPPED	2

		jr	c, loc_7E11
		jr	nz, loc_7E11

		ld	e, 34h ; '4'
		ld	b, 1
		call	loc_7DCA

		jr	loc_7E31

loc_7E11:
		GET_GAME_VARIABLE	VAR_10			; ???

		jr	z, loc_7E23
		ld	a, c

		cp	(iy+VAR_4C)
		jr	nz, loc_7E23

		ld	a, (GAME_VARIABLES + VAR_11)

		cp	3
		jr	z, loc_7E2A

loc_7E23:
		CHECK_EQUIPPED	1

		jr	c, loc_7E31
		jr	nz, loc_7E31

loc_7E2A:
		ld	e, 30h ; '0'
		ld	b, 1
		call	loc_7DCA

loc_7E31:
		dec	c
		jr	nz, loc_7DFE

		dec	(iy+VAR_PAUSE)		; pause OFF

		ret
