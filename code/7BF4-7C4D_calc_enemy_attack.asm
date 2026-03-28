loc_7BF4:
		xor	a
		ld	(GAME_VARIABLES + VAR_50), a
		ld	a, (GAME_VARIABLES + VAR_53)

		FIND_HERO_BY_A

		ld	c, (ix+CHAR_NATURAL_AC)
		ld	e, (iy+VAR_4E)

		GET_E_FROM_TABLE	2Dh

		add	a, c

		cp	15h
		jr	c, loc_7C0D

		ld	a, 15h

loc_7C0D:
		ld	c, a

		GET_E_FROM_TABLE	41h

		GET_A_FROM_TABLE	INX_MONST_SPEC

		ld	l, a
		and	1Fh
		ld	b, a
		inc	b
		srl	a
		ld	h, a

		GET_RND_BY_PARAM	7

		add	a, h
		ld	h, a

		GET_RND_BY_PARAM	7

		add	a, h
		add	a, 2
		ld	h, a

		GET_E_FROM_TABLE	2Ch

		ld	e, a
		add	a, h

		cp	c
		ret	c

		ld	a, l
		rlca
		rlca
		rlca
		and	7
		ld	(GAME_VARIABLES + VAR_50), a
		ld	hl, 0

loc_7C3B:
		GET_RND_BY_PARAM	3

		inc	a
		add	a, l
		ld	l, a

		jr	nc, loc_7C44

		inc	h

loc_7C44:
		djnz	loc_7C3B

		ld	a, e
		add	a, l
		ld	l, a
		jr	nc, loc_7C4C

		inc	h

loc_7C4C:
		and	a

		ret
