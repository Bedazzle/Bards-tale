enemies_killed:
		RST_10_29

		xor	a
		ld	(GAME_VARIABLES + VAR_36), a

		cp	(iy+VAR_UNDERGROUND)
		jr	z, collect_loot

		cp	(iy+VAR_3F)
		jr	z, collect_loot

		ld	a, 9
		call	sub_C198

collect_loot:
		ld	b, 92h			; text: Treasure!
		ld	a, PIC_GRAVE

		SHOW_NAME_PIC_AB

		call	nullify_FDDD
		ld	l, a
		ld	h, a
		ld	(GAME_VARIABLES + VAR_76), hl
		ld	(GAME_VARIABLES + VAR_43), hl
		ld	(GAME_VARIABLES + VAR_INFO_ROW_POS),	a
		ld	(GAME_VARIABLES + VAR_45), a
		ld	b, 0Fh

loc_7E66:
		GET_RND_NUMBERS

		GET_IY_A_FROM_TABLE	54h, 28h

		and	(iy+VAR_RND_LO)
		ld	h, a
		jr	nz, loc_7E7A

		ld	a, (GAME_VARIABLES + VAR_RND_HI)
		or	7
		ld	(GAME_VARIABLES + VAR_RND_HI), a

loc_7E7A:
		GET_IY_A_FROM_TABLE	54h, 29h

		and	(iy+VAR_RND_HI)
		ld	l, a
		ld	(GAME_VARIABLES + VAR_74), hl

		GET_B_FROM_TABLE	2Bh

		jr	z, loc_7ECC

		ld	c, a

		GET_C_FROM_TABLE	INX_XP_TABLE

		ld	e, a
		ld	a, c

		cp	10h
		jr	nc, loc_7E98

		ld	d, 0

		jr	loc_7E9B
; -------------------------------------

loc_7E98:
		ld	d, e
		ld	e, 0

loc_7E9B:
		GET_B_FROM_TABLE	2Ah

		jr	z, loc_7ECC

		ld	c, a
		ld	hl, (GAME_VARIABLES + VAR_43)

loc_7EA4:
		push	de

		GET_RND_BY_PARAM	7

		jr	nz, loc_7EAD

		inc	(iy+VAR_INFO_ROW_POS)

loc_7EAD:
		add	hl, de
		jr	nc, loc_7EB3

		inc	(iy+VAR_45)

loc_7EB3:
		GET_GAME_VARIABLE	VAR_36		; ???

		jr	nz, loc_7EC5

		push	hl
		ld	hl, (GAME_VARIABLES + VAR_74)
		ld	de, (GAME_VARIABLES + VAR_76)
		add	hl, de
		ld	(GAME_VARIABLES + VAR_76), hl
		pop	hl

loc_7EC5:
		pop	de
		dec	c
		jr	nz, loc_7EA4

		ld	(GAME_VARIABLES + VAR_43), hl

loc_7ECC:
		dec	b
		jp	p, loc_7E66

		CLEAR_INFO_PANEL


		PRINT_MESSAGE	2Ah			; "Each character receives"

		ld	a, 14h
		call	loc_7F79
		call	loc_88E5

		PRINT_MESSAGE	78h			; "experience points for valor and battle knowledge,"

		PRINT_MESSAGE	69h			; "and"

		ld	hl, (GAME_VARIABLES + VAR_76)
		ld	a, l

		cp	0Eh
		jr	nc, loc_7EED

		ld	l, 0Eh

loc_7EED:
		ld	a, 24h
		call	loc_7F79
		call	loc_88E5

		PRINT_MESSAGE	79h			; "pieces of gold."

		GET_GAME_VARIABLE	VAR_36		; ???

		jr	nz, no_more_loot

		GET_GAME_VARIABLE	VAR_INFO_ROW_POS

		ld	c, a
		ld	a, (iy+VAR_COPY_DAYPART)
		jr	nz, loc_7F0B

		cp	4
		jr	c, loc_7F0B

		inc	c

loc_7F0B:
		add	a, 0FCh
		ld	a, 1
		adc	a, 0

		cp	c
		jr	nc, loc_7F15

		ld	c, a

loc_7F15:
		dec	c
		inc	c
		jr	z, no_more_loot

		CHANGE_SPEED 0Fh

		GET_RND_NUMBERS

		ld	b, a

		GET_IY_A_FROM_TABLE	54h, 4Fh

		and	b
		ld	b, a

		GET_IY_A_FROM_TABLE	54h, 50h

		add	a, b
		jr	nz, loc_7F2D

		inc	a

loc_7F2D:
		ld	e, a

		GET_RND_BY_PARAM	7

		cp	7
		ld	d, 0
		jr	nz, loc_7F39

		ld	d, 0F0h

loc_7F39:
		RST_10_51

		or	a
		jr	z, loc_7F39

		FIND_HERO_BY_A

		ld	h, 6

loc_7F42:
		ld	a, b
		call	loc_7639
		jr	nc, treasure_found

loc_7F48:
		dec	h
		jr	z, no_more_loot

		dec	b
		jr	nz, loc_7F50

		ld	b, 6

loc_7F50:
		FIND_HERO_BY_B

		CHECK_HERO_STATUS

		jr	c, loc_7F42

		jr	loc_7F48
; -------------------------------------

treasure_found:
		PRINT_NEWLINE

		PRINT_IX_HERO_NAME

		PRINT_MESSAGE	7Ah			; "found a"

		PRINT_SPACE

		ld	a, d
		add	a, a
		ld	a, e
		jr	nc, loc_7F6D

		GET_E_FROM_TABLE	INX_ITEM_SPECATT

		and	0Fh
		or	80h

loc_7F6D:
		PRINT_ITEM_NAME

		PRINT_MESSAGE	63h			; ===empty message===

		dec	c

		jr	loc_7F15
; -------------------------------------

no_more_loot:
		CHANGE_SPEED 19h

		ret
