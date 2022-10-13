shoppe_buy:
		ld	c, 1

		CLEAR_INFO_PANEL

start_buy:
		RESET_ROW_COL

		ld	b, 0
		ld	l, c

loc_E42C:
		GET_L_FROM_TABLE	16h

		jr	z, loc_E458
		
		ld	a, b

		PRINT_NEXT_DIGIT

		GET_ATTR_BY_PARAM_SAVE_HL	CHAR_CLASS

		GET_A_FROM_TABLE	46h

		ld	h, a

		GET_L_FROM_TABLE	INX_ITEM_EQUIP

		and	h
		jr	nz, loc_E445

		ld	a, 5Eh ; '^'

		jr	loc_E447
; -------------------------------------

loc_E445:
		ld	a, 2Eh ; '.'

loc_E447:
		PRINT_WITH_CODES

		ld	a, l
		call	loc_C00A
		call	sub_E5F3
		ld	a, 28h ; '('
		call	print_spaces_eol

		PRINT_NEWLINE

		inc	b

loc_E458:
		inc	l
		ld	a, l
		and	7Fh
		ld	l, a
		ld	a, b

		cp	9
		jr	c, loc_E42C

		call	loc_E5EB

shoppe_menu:
		RESET_COL

		ld	(iy+VAR_CURSOR_ROW), 0Eh

		PRINT_MESSAGE2	4		; "P)urc F)orw B)ack"

		WAIT_KEY_DOWN

		cp	'P'
		jr	z, purchase

		cp	'F'
		jr	z, shoppe_forw

		cp	'B'
		jp	nz, loop_shoppe

shoppe_back:
		dec	c
		jp	m, shoppe_back

		GET_C_FROM_TABLE	16h

		jr	z, shoppe_back
		jr	start_buy
; -------------------------------------

shoppe_forw:
		inc	c
		jp	m, shoppe_forw

		GET_C_FROM_TABLE	16h

		jr	z, shoppe_forw
		jr	start_buy
; -------------------------------------

purchase:
		PRINT_SPACE_LINE

		PRINT_MESSAGE2	5		; "Purchase (1-9)"

		RESET_COL

		WAIT_KEY_DOWN

		sub	'1'
		jr	c, shoppe_menu

		cp	9
		jr	nc, shoppe_menu

		ld	h, 0
		ld	e, c

loc_E4A7:
		cp	h
		jr	z, loc_E4B8

		inc	h
		push	af

loc_E4AC:
		inc	e
		jp	m, loc_E4AC

		GET_E_FROM_TABLE	16h

		jr      z, loc_E4AC

		pop	af
		jr	loc_E4A7
; -------------------------------------

loc_E4B8:
		GET_E_FROM_TABLE	13h

		push	de
		ld	e, CHAR_GOLD_START
		call	loc_77B0
		pop	de
		jr	nc, loc_E4CF

		PRINT_MESSAGE	1Bh			; "Not enough"

		PRINT_MESSAGE	7Bh			; "gold"

loc_E4CA:
		CHANGE_SPEED 0Ah

		jr	shoppe_menu
; -------------------------------------

loc_E4CF:
		ld	d, 0

		GET_ATTR_BY_PARAM_SAVE_HL	CHAR_POS_IN_PARTY

		call	all_full
		jr	c, loc_E4CA

		ld	h, e
		ld	e, CHAR_GOLD_START
		call	decreas_12_digits

		PRINT_SPACE_LINE

		PRINT_MESSAGE	1Ch			; "Done!"

		CHANGE_SPEED 0Ah

		GET_H_FROM_TABLE	16h

		cp	0FEh
		jr	nc, loc_E4F1

		exx
		dec	(hl)
		exx

loc_E4F1:
		jp	start_buy
