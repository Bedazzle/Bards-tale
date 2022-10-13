loc_7828:
		RST_10_2A

		jr	c, loc_7832

loc_782C:
		PRINT_MESSAGE	6Ah			; "but it had no effect!"

		jp	dyn_proc_54

loc_7832:
		CLEAN_ALLY_MEMORY

		ld	a, (GAME_VARIABLES + VAR_53)
		and	7Fh
		ld	c, a

		GET_C_FROM_TABLE	42h

		jr	nz, loc_782C

		GET_C_FROM_TABLE	36h

		jr	z, loc_782C
		dec	a
		exx
		ld	(hl), a
		exx

		GET_C_FROM_TABLE	41h

		call	loc_7864
		ld	b, c

		CALC_IN_FB7D

		ld	b, 64h ; 'd'

loc_7853:
		ld	a, (hl)
		inc	hl
		or	a
		jr	nz, loc_785B

		djnz	loc_7853

		inc	a

loc_785B:
		ld	(ENEMY+ENEMY_COND), a
		ld	(ENEMY+ENEMY_HITS), a

		jp	print_ellipsis
; -------------------------------------

loc_7864:
		ld	l, a
		ld	d, a
		ld	b, 0
		ld	h, b

		FIND_HERO_BY_B

		xor	a
		ld	(GAME_VARIABLES + VAR_4F), a
		ld	a, l

		PRINT_EMPTY

		add	hl, hl
		add	hl, hl
		ld	b, h
		ld	c, l
		ld	hl, ENEMY + ENEMY_11
		ld	e, 4

loc_787B:
		call	sub_713D
		ld	(hl), a
		inc	bc
		inc	hl
		dec	e
		jr	nz, loc_787B

		GET_D_FROM_TABLE	INX_MONST_SPEC

		ld	(hl), a
		inc	hl
		ld	(hl), d
		inc	hl
		ld	a, 17h

loc_788D:
		ld	(hl), 0

loc_788F:
		inc	hl
		inc	a

		cp	'1'
		jr	z, loc_788F

		cp	'3'
		jr	z, loc_788F

		cp	'?'
		jr	c, loc_788D

		GET_D_FROM_TABLE	INX_MONST_HP_AC

		and	1Fh
		ld	(hl), a
		ld	(ix+CHAR_CLASS), 0Ah

		ret
