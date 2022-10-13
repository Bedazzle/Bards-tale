proc_temple:
		SHOW_NAME_AND_PICTURE	0, PIC_TEMPLE		; Temple

temple_welcome:
		CLEAR_INFO_PANEL

		PRINT2_IN_LOOP
		db    1,   9,	8, 5Ch,0FFh		; "Welcome"
										; "oh weary ones, to our humble temple. Who needeth healing?"
										; "(E)xit"
										; "temple"

loop_temple_hero:
		call	enter_hero_num
		jr	nc, enter_temple

		cp	'E'
		jr	nz, loop_temple_hero

		jp	process_exit
; -------------------------------------

enter_temple:
		CLEAR_INFO_PANEL

		PRINT_IX_HERO_NAME

		GET_ATTR_BY_PARAM	CHAR_STATUS

		jr	nz, loc_E62A

		call	sub_E8A8
		jr	nz, loc_E62F

		ld	a, 2
		ld	(hl), a

loc_E62A:
		PRINT_MESSAGE2	5Fh		; "is in bad shape, indeed."

		jr	loc_E681
; -------------------------------------

loc_E62F:
		xor	a
		ld	(GAME_VARIABLES + VAR_37), a

		GET_ATTR_BY_PARAM	CHAR_HITS_LO

		inc	hl
		inc	hl
		sub	(hl)
		ld	e, a
		dec	hl
		dec	hl
		dec	hl
		ld	a, (hl)
		inc	hl
		inc	hl
		sbc	a, (hl)
		ld	d, a
		or	e
		jr	nz, loc_E66B

		GET_ATTR_BY_PARAM	CHAR_MAXLEVEL_HI

		inc	hl
		inc	hl

		cp	(hl)
		jr	z, loc_E651
		jr	nc, loc_E65A
		jr	loc_E664
; -------------------------------------

loc_E651:
		dec	hl
		ld	a, (hl)
		inc	hl
		inc	hl

		cp	(hl)
		jr	z, loc_E664
		jr	c, loc_E664

loc_E65A:
		inc	(iy+VAR_37)

		PRINT_MESSAGE2	62h		; "has been drained of life force."

		ld	a, 8
		jr	loc_E681
; -------------------------------------

loc_E664:
		PRINT_MESSAGE2	5Eh		; "does not require any healing."

		CHANGE_SPEED_TO_8

		jr	temple_welcome
; -------------------------------------

loc_E66B:
		PRINT_MESSAGE2	61h		; "has wounds which need tending."

		ex	de, hl
		ld	b, 0
		ld	d, b
		ld	e, b

loc_E673:
		ld	c, 1
		and	a
		sbc	hl, bc
		jr	c, loc_E6A1
		ld	c, 0Ah
		ex	de, hl
		add	hl, bc
		ex	de, hl

		jr	loc_E673
; -------------------------------------

loc_E681:
		add	a, a
		ld	h, a

		GET_H_FROM_TABLE	12h

		ld	e, a
		inc	h

		GET_H_FROM_TABLE	12h

		ld	d, a
		ld	hl, 0
		ld	b, 0Dh

		GET_ATTR_BY_PARAM	CHAR_LEVEL_HI

		jr	nz, loc_E69D

		inc	hl
		ld	a, (hl)

		cp	0Eh
		jr	nc, loc_E69D

		ld	b, a

loc_E69D:
		add	hl, de
		djnz	loc_E69D

		ex	de, hl

loc_E6A1:
		PRINT_MESSAGE2	5Dh			; "It will cost"

		PRINT_NUM_FROM_DE

		PRINT2_IN_LOOP
		db  6Fh, 17h,0FFh			; "in gold."
									; "Who will pay?"

		PRINT_MESSAGE	44h			; "(1-6)"

		GET_ATTR_BY_PARAM_SAVE_HL	64h			; get hero position in party

		ld	b, a
		call	enter_hero_num
		jp	c, temple_welcome

		ld	e, CHAR_GOLD_START
		push	bc
		call	check_12_digits
		pop	bc
		jr	nc, loc_E6D0

		FIND_HERO_BY_B

		PRINT_2_NEWLINES

		PRINT_MESSAGE	1Bh			; "Not enough"

		PRINT_MESSAGE	7Bh			; "gold"

		CHANGE_SPEED_TO_8

		jp	enter_temple
; -------------------------------------

loc_E6D0:
		ld	e, CHAR_GOLD_START
		call	decreas_12_digits

		FIND_HERO_BY_B

		GET_ATTR_BY_PARAM	CHAR_STATUS

		jr	z, loc_E705

		push	af
		xor	a
		ld	(hl), a
		ld	(ix+CHAR_FORMER_HEALTH), a
		pop	af

		cp	2
		jr	z, loc_E6F4

		cp	6
		jr	nz, loc_E6F7

		ld	a, 32h

		GET_ATTR_BY_A

		xor	a
		ld	(hl), a

         inc     hl
         jr      loc_E701

loc_E6F4:
		call	sub_E8BC

loc_E6F7:
		GET_ATTR_BY_PARAM	CHAR_COND_HI

		jr	nz, loc_E738

		inc	hl
		ld	a, (hl)
		or	a
		jr	nz, loc_E738

loc_E701:
		ld	(hl), 1

		jr	loc_E738
; -------------------------------------

loc_E705:
		RST_10_00	37h

		jr	z, loc_E72D

		dec	(hl)

		GET_ATTR_BY_PARAM	CHAR_MAXLEVEL_HI

		ld	d, a
		ld	(ix+CHAR_LEVEL_HI), a
		inc	hl
		ld	a, (hl)
		ld	e, a
		ld	(ix+CHAR_LEVEL_LO), a
		dec	de
		ex	de, hl
		call	loc_76B9
		ld	b, 0Ch

		GET_ATTR_BY_PARAM	CHAR_EXP_END

		ld	de, addr_FB5B

loc_E725:
		ld	a, (de)
		ld	(hl), a
		dec	hl
		dec	de
		djnz	loc_E725

		jr	loc_E738
; -------------------------------------

loc_E72D:
		GET_ATTR_BY_PARAM	CHAR_HITS_HI

		ld	(ix+CHAR_COND_HI), a
		inc	hl
		ld	a, (hl)
		ld	(ix+CHAR_COND_LO), a

loc_E738:
		PRINT_MESSAGE2	0Ah			; "The preists lay hands on him..."

		CHANGE_SPEED_TO_8

		PRINT_MESSAGE2	60h			; "...and he is healed!"

		RST_10_4A

		CHANGE_SPEED_TO_8

		jp	temple_welcome
