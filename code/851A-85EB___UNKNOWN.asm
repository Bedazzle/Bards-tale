loc_851A:
		and	a, 40h
		jr	z, loc_8528

		ld	a, b
		and	a, 3Fh
		ld	e, a

		GET_RND_BY_PARAM	1

		add	a, e
		jr	nz, loc_852B

loc_8528:
		ld	a, b
		and	3Fh

loc_852B:
		ld	b, a

		GET_GAME_VARIABLE	VAR_ACTIVE_HERO		; ???

		jp	z, print_ellipsis
		jr	c, loc_85AB

		CLEAN_ALLY_MEMORY

		GET_B_FROM_TABLE	INX_SUMMON_CREAT

		cp	5
		jr	c, loc_854C

		push	af

		RST_10_5C

		ld	(ENEMY+ENEMY_HITS), a
		ld	(ENEMY+ENEMY_COND), a
		pop	af
		call	loc_7864

		jr	loc_8584
; -------------------------------------

loc_854C:
		ld	b, a

		GET_B_FROM_TABLE	63h

		ld	l, a
		inc	b

		GET_B_FROM_TABLE	63h

		ld	h, a

setup_enemy:
		ld	bc, 17h
		ld	de, ENEMY
		ldir

		ex	de, hl
		inc	hl
		ld	a, 18h

loc_8562:
		ld	(hl), 0
		inc	hl
		inc	a

		cp	3Fh ; '?'
		jr	c, loc_8562

		ex	de, hl
		ld	a, (hl)
		ld	(de), a
		inc	hl
		ld	e, (hl)
		inc	hl
		ld	d, (hl)

		GET_RND_NUMBERS

		and	e
		add	a, d
		jr	nc, loc_8579

		ld	a, 0FFh

loc_8579:
		ld	(ENEMY+ENEMY_COND), a
		ld	(ENEMY+ENEMY_HITS), a
		ld	a, CLASS_PARTY
		ld	(ENEMY+ENEMY_CLASS), a

loc_8584:
		call	loc_891E
		jr	c, loc_858C

		xor	a

		jr	loc_8592
; -------------------------------------

loc_858C:
		ld	hl, addr_5D20
		inc	(hl)
		ld	a, 1

loc_8592:
		ld	(ENEMY+ENEMY_17), a
		ld	b, 6

loc_8597:
		GET_B_FROM_TABLE	51h

		jr	nz, loc_85A6

		GET_B_FROM_TABLE	56h

		cp	1
		jr	nz, loc_85A6

		exx
		inc	(hl)
		exx

loc_85A6:
		djnz	loc_8597

loc_85A8:
		jp	print_ellipsis
; -------------------------------------

loc_85AB:
		ld	e, b

		RST_10_5D

		jr	c, loc_85A8

		inc	b
		ld	a, b

		cp	4
		jr	nc, loc_85A8

		GET_E_FROM_TABLE	INX_SUMMON_CREAT

		call	loc_85D9
		call	loc_891E
		jr	c, loc_85C7

		GET_E_FROM_TABLE	42h

		exx
		inc	(hl)
		exx

loc_85C7:
		PRINT_MESSAGE	69h			; "and"

		xor	a
		ld	(GAME_VARIABLES + VAR_4F), a

		GET_B_FROM_TABLE	41h

		PRINT_WORD

		PRINT_MESSAGE	6Ch			; "appears"

		jp	print_ellipsis
; -------------------------------------

loc_85D9:
		GET_B_FROM_LIST	41h

		GET_B_FROM_TABLE	36h

		exx
		inc	(hl)
		exx

		CALC_IN_FB7D

		RST_10_5C

		ld	(hl), a

		RST_10_57

		ld	(hl), 0
		ret
