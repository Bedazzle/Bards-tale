do_advancement:
		CLEAR_INFO_PANEL

		PRINT2_IN_LOOP
		db  0Bh, 69h, 0Fh,0FFh		; "The Guild leaders"
									; "prepare to weigh thy merits."
									; "Who shall be reviewed?"

		PRINT_MESSAGE	44h			; "(1-6)"

		call	enter_hero_num
		jr	c, reset_reviewboard

		CHECK_HERO_STATUS

		jr	nc, reset_reviewboard

		CLEAR_INFO_PANEL

		PRINT2_IN_LOOP
		db  0Bh, 68h,0FFh			; "The Guild leaders"
									; "deem that"

		PRINT_IX_HERO_NAME

		GET_ATTR_BY_PARAM	CHAR_LEVEL_HI

		inc	hl
		ld	l, (hl)
		ld	h, a
		call	loc_76B9
		jr	nc, increase_char_level

not_enough_exp:
		PRINT_MESSAGE2	6Ch			; "still needeth"

		ld	e, CHAR_EXP_START
		call	get_attr_param
		call	loc_88E5

		PRINT_MESSAGE2	6Dh			; "experience points prior to advancement."

loc_E986:
		call	sub_75BF

		PRINT_AND_WAIT

		jr	do_advancement
; -------------------------------------

increase_char_level:
		PRINT_MESSAGE2	6Bh			; "hath earned a level of advancement..."

		FIND_ATTR_AND_ADDRESS	CHAR_LEVEL_LO

		inc	(hl)
		dec	hl
		jr	nz, loc_E998

		inc	(hl)

loc_E998:
		dec	hl
		inc	(hl)
		dec	hl
		jr	nz, loc_E99E

		inc	(hl)

loc_E99E:
		call	sub_E8A8
		call	z, sub_E8BC
		call	unpack_hero_attrs
		ld	b, (ix+CHAR_CLASS)

		GET_B_FROM_TABLE	0Eh

		ld	b, a

		GET_RND_NUMBERS

		and	b
		ld	b, a
		ld	a, (byte_FB5D)
		call	sub_EBAB

		FIND_ATTR_AND_ADDRESS	CHAR_COND_LO

		call	sub_EBB4

		GET_ATTR_BY_PARAM_SAVE_HL	CHAR_CLASS		; get hero class

		jr	z, unk_E9F8

		cp	CLASS_ROGUE
		jr	z, loc_E9DB
		jr	nc, unk_E9F8

		GET_RND_BY_PARAM	3

		ld	b, a
		ld	a, (byte_FB5D)
		call	sub_EBAB

		FIND_ATTR_AND_ADDRESS	CHAR_SPPT_LO

		call	sub_EBB4

		jr	loc_EA24
; -------------------------------------

loc_E9DB:
		ld	b, 3

		FIND_ATTR_AND_ADDRESS	CHAR_ROGUE_DISARM

loc_E9E0:
		ld	a, (byte_FB5E)
		sub	0Eh
		jr	nc, loc_E9E8

		xor	a

loc_E9E8:
		ld	e, a

		GET_RND_BY_PARAM	7

		add	a, e
		add	a, (hl)
		jr	nc, loc_E9F2

		ld	a, 0FFh

loc_E9F2:
		ld	(hl), a
		inc	hl
		djnz	loc_E9E0

		jr	loc_EA24
; -------------------------------------
unk_E9F8:
		cp	8
		jr	nz, loc_EA03

		FIND_ATTR_AND_ADDRESS	CHAR_HUNTER_CHANCE

		ld	b, 1

		jr	loc_E9E0
; -------------------------------------

loc_EA03:
		cp	0
		jr	z, loc_EA0F

		cp	7
		jr	z, loc_EA0F

		cp	9
		jr	nz, loc_EA24

loc_EA0F:
		GET_ATTR_BY_PARAM	CHAR_LEVEL_HI

		jr	nz, loc_EA1F

		inc	hl
		ld	a, (hl)
		dec	a
		srl	a
		srl	a

		cp	8
		jr	c, loc_EA21

loc_EA1F:
		ld	a, 7

loc_EA21:
		ld	(ix+CHAR_ATT_ROUND), a

loc_EA24:
		GET_RND_BY_PARAM	7

		cp	5
		jr	c, loc_EA2D

		sub	5

loc_EA2D:
		ld	e, a
		ld	b, 5

loc_EA30:
		GET_E_FROM_TABLE	48h

		cp	12h
		jr	c, loc_EA44

		inc	e
		ld	a, e

		cp	5
		jr	c, loc_EA3F

		ld	e, 0

loc_EA3F:
		djnz	loc_EA30

		jp	loc_E986
; -------------------------------------

loc_EA44:
		exx
		inc	(hl)
		exx

		PRINT_MESSAGE2	6Eh			; "+1 to"

		ld	a, e
		add	a, 80h

		PRINT2_A_WITH_FLAG_0

		call	pack_hero_attrs

		jp	loc_E986
