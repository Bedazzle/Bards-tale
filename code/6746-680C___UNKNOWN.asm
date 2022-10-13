loc_6746:
		GET_GAME_VARIABLE	VAR_61			; ???

		jr	z, loc_6758

		ld	hl, addr_FDD6
		ld	b, 7
		call	nullify_buffer
		ld	(GAME_VARIABLES + VAR_61), a

		jr	loc_67C6

loc_6758:
		ld	b, 1
		ld	hl, addr_FDD1

loc_675D:
		FIND_HERO_BY_B

		jr	z, loc_67C6

		GET_ATTR_BY_PARAM_SAVE_HL	CHAR_WON_COMBATS_HI

		srl	a
		ld	c, a

		GET_ATTR_BY_PARAM_SAVE_HL	CHAR_PARAMS_LO

		and	1Fh
		sub	0Eh
		jr	c, loc_6779

		rla
		rla
		rla
		and	0F8h
		add	a, c
		jr	c, loc_67B8

		ld	c, a

loc_6779:
		GET_RND_BY_PARAM	1Fh

		add	a, c
		jr	c, loc_67B8

		push	hl

		GET_ATTR_BY_PARAM	CHAR_LEVEL_HI

		srl	a
		ld	d, a
		inc	hl
		ld	a, (hl)
		pop	hl
		rra
		ld	e, a
		ld	a, d
		or	a
		jr	nz, loc_6794

		ld	a, e

		cp	41h ; 'A'
		jr	nc, loc_6797

loc_6794:
		ld	de, 40h

loc_6797:
		GET_ATTR_BY_PARAM_SAVE_HL	CHAR_CLASS

		jr	z, loc_67B4

		cp	CLASS_ROGUE
		jr	c, loc_67AC

		cp	CLASS_PALADIN
		jr	c, loc_67B2

		cp	CLASS_MONK
		jr	c, loc_67B4

		sla	e
		jr	loc_67B4

loc_67AC:
		srl	e
		srl	e

		jr	loc_67B4

loc_67B2:
		srl	e

loc_67B4:
		ld	a, e
		add	a, c
		jr	nc, loc_67BA

loc_67B8:
		ld	a, 0FFh

loc_67BA:
		or	a
		jr	nz, loc_67BE

		inc	a

loc_67BE:
		ld	(hl), a
		inc	hl
		inc	b
		ld	a, b

		cp	7
		jr	c, loc_675D

loc_67C6:
		ld	a, (ENEMY+ENEMY_ALIVE)
		or	a
		jr	z, loc_67DF

		ld	a, (ENEMY+ENEMY_15)
		and	1Fh
		add	a, a
		add	a, a
		ld	c, a

		GET_RND_BY_PARAM	1Fh

		add	a, c
		jr	nc, loc_67DC

		ld	a, 0FFh

loc_67DC:
		ld	(___table_95+51h), a

loc_67DF:
		ld	b, 0

loc_67E1:
		GET_B_FROM_TABLE	41h

		jr	z, loc_6802

		RST_10_61	70h, 1Fh

		add	a, a
		add	a, a
		ld	c, a

		RST_10_57

		GET_B_FROM_TABLE	36h

		jr	z, loc_6802

		ld	e, a

loc_67F5:
		GET_RND_BY_PARAM	1Fh

		add	a, c
		jr	nc, loc_67FD

		ld	a, 0FFh

loc_67FD:
		ld	(hl), a
		dec	e
		inc	hl
		jr	nz, loc_67F5

loc_6802:
		ld	a, b

		cp	4
		ret	nc

		cp	(iy+VAR_4D)
		ret	nc

		inc	b

		jr	loc_67E1
