loc_7AB8:
		push	ix
		xor	a
		ld	(GAME_VARIABLES + VAR_50), a

		GET_GAME_VARIABLE	VAR_53			; ???

		jr	c, loc_7ACA

		FIND_HERO_BY_A

		ld	a, (ix+CHAR_NATURAL_AC)

		jr	loc_7ADB

loc_7ACA:
		and	7Fh
		ld	c, a

		GET_C_FROM_TABLE	2Eh

		ld	e, a

		GET_C_FROM_TABLE	41h

		GET_A_FROM_TABLE	INX_MONST_HP_AC

		sub	e
		jr	nc, loc_7ADB

		xor	a

loc_7ADB:
		pop	ix
		ex	af, af'

		GET_ATTR_BY_PARAM_SAVE_HL	CHAR_POS_IN_PARTY

		ld	(GAME_VARIABLES + VAR_6D), a
		jr	nz, loc_7AE9

		ld	c, a

		jr	loc_7B1B
; -------------------------------------

loc_7AE9:
		ld	a, (ix+CHAR_PARAMS_HI)
		call	divide_A_by_8
		sub	0Fh
		jr	nc, loc_7AF4

		xor	a

loc_7AF4:
		ld	c, a
		xor	a
		ld	(GAME_VARIABLES + VAR_34), a
		ld	e, 1
		call	loc_7A9E
		jr	c, loc_7B1B

		inc	(iy+VAR_34)

		GET_D_FROM_TABLE	INX_WEAPON_BONUS

		call	divide_A_by_16
		ld	e, a
		add	a, c
		ld	c, a

		GET_D_FROM_TABLE	INX_ITEM_SPECATT

		call	divide_A_by_16
		ld	(GAME_VARIABLES + VAR_50), a
		ex	af, af'
		sub	e
		jr	nc, loc_7B1A

		xor	a

loc_7B1A:
		ex	af, af'

loc_7B1B:
		ld	a, (ix+CHAR_CLASS)

		GET_A_FROM_TABLE	4Ch

		ld	e, a
		ex	af, af'
		sub	e
		jr	c, loc_7B2B

		sub	(iy+VAR_64)
		jr	nc, loc_7B2C

loc_7B2B:
		xor	a

loc_7B2C:
		add	a, (iy+VAR_62)

		cp	15h
		jr	c, loc_7B35

		ld	a, 15h

loc_7B35:
		ld	e, a

		GET_RND_BY_PARAM	7

		ld	d, a

		GET_RND_BY_PARAM	7

		add	a, d
		add	a, 3
		ld	d, a

		GET_IY_A_FROM_TABLE	6Dh, 2Fh

		add	a, d

		cp	e
		ret	c

		GET_GAME_VARIABLE	VAR_6D			; ???

		jr	nz, loc_7B60
		ld	a, (ix+CHAR_15)
		ld	b, a
		rlca
		rlca
		rlca
		and	7
		ld	(GAME_VARIABLES + VAR_50), a
		ld	a, b
		and	1Fh
		or	20h ; ' '

		jr	loc_7B88
; -------------------------------------

loc_7B60:
		ld	e, 1
		call	loc_7A9E
		jr	nc, loc_7B85

		ld	a, (ix+CHAR_CLASS)

		cp	CLASS_MONK
		jr	nz, loc_7B82

		GET_ATTR_BY_PARAM	CHAR_LEVEL_HI

		jr	nz, loc_7B7B

		inc	hl
		ld	a, (hl)
		srl	a

		cp	20h ; ' '
		jr	c, loc_7B7D

loc_7B7B:
		ld	a, 1Fh

loc_7B7D:
		GET_A_FROM_TABLE	6Ch

		jr	loc_7B88

loc_7B82:
		xor	a

		jr	loc_7B88
; -------------------------------------

loc_7B85:
		GET_D_FROM_TABLE	INX_WEAPON_DAMAGE

loc_7B88:
		push	af
		rlca
		rlca
		rlca
		and	7
		ld	b, a
		pop	af
		and	1Fh
		ld	e, a
		inc	e
		ld	a, c
		ex	af, af'

		GET_B_FROM_TABLE	4Dh

		ld	c, a
		ld	hl, 0
		ld	d, (ix+CHAR_ATT_ROUND)

loc_7BA0:
		ld	b, e
		push	de

loc_7BA2:
		GET_RND_NUMBERS

		and	c
		ld	d, 0
		ld	e, a
		scf
		adc	hl, de
		djnz	loc_7BA2

		ex	af, af'
		ld	e, a
		add	hl, de
		ld	e, (iy+VAR_5F)
		add	hl, de

		GET_IY_A_FROM_TABLE	6Dh, 30h

		ld	e, a
		add	hl, de

		GET_IY_A_FROM_TABLE	6Dh, 2Fh

		jr	z, loc_7BC9

		ld	b, a

loc_7BC1:
		GET_RND_BY_PARAM	7

		ld	e, a
		inc	e
		add	hl, de
		djnz	loc_7BC1

loc_7BC9:
		ld	e, (iy+VAR_62)
		and	a
		sbc	hl, de
		jr	nc, loc_7BD4
		ld	hl, 1

loc_7BD4:
		pop	de
		dec	d
		jp	p, loc_7BA0

		ld	a, (ix+CHAR_CLASS)

		cp	CLASS_HUNTER
		jr	nz, loc_7BEB

		GET_RND_NUMBERS

		cp	(ix+CHAR_HUNTER_CHANCE)
		jr	nc, loc_7BEB

		ld	(iy+VAR_50), 7

loc_7BEB:
		and	a

		ret
