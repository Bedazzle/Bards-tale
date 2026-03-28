loc_6ACC:
		or	a
		jr	nz, loc_6ADA

		ld	a, (ENEMY+ENEMY_16)
		call	divide_A_by_8
		add	a, (iy+VAR_60)

		jr	loc_6B1D

loc_6ADA:
		ld	c, a

		FIND_HERO_BY_A

		GET_ATTR_BY_PARAM	CHAR_LEVEL_HI

		jr	nz, loc_6AEA

		inc	hl
		ld	a, (hl)
		srl	a

		cp	12h
		jr	c, loc_6AEC

loc_6AEA:
		ld	a, 12h

loc_6AEC:
		add	a, (iy+VAR_60)
		ld	d, a
		ld	a, c
		ld	c, 0

		CHECK_EQUIPPED	6

		jr	c, loc_6AFA
		ld	c, 2

loc_6AFA:
		GET_ATTR_BY_PARAM_SAVE_HL	CHAR_CLASS

		cp	CLASS_PALADIN
		jr	nz, loc_6B11

		GET_ATTR_BY_PARAM_SAVE_HL	CHAR_LEVEL_LO

		srl	a

		cp	10h
		jr	c, loc_6B0C

		ld	a, 0Fh

loc_6B0C:
		GET_A_FROM_TABLE	3Dh

		jr	loc_6B14

loc_6B11:
		GET_A_FROM_TABLE	3Eh

loc_6B14:
		add	a, d
		ld	d, a

		GET_ATTR_BY_PARAM_SAVE_HL	CHAR_12		; ???

		and	7
		add	a, d
		add	a, c

loc_6B1D:
		ld	c, a

		GET_RND_BY_PARAM	7

		add	a, c
		inc	a

		ret
