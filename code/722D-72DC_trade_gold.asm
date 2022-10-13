trade_gold:
		PRINT_SPACE_LINE

		PRINT_IN_LOOP
		db  15h, 45h, 0FFh			; "Trade Gold,"
									; "(1-8)"

		ENTER_1_TO_8

		jr	nc, check_is_equipped

		cp	47h
		ret	nz

		PRINT_SPACE_LINE

		dec	(iy+VAR_CURSOR_ROW)
		call	loc_623B
		ret	c

		call	ascii_to_num
		ret	c

		ld	e, CHAR_GOLD_START
		call	check_12_digits
		jr	nc, ready_for_trade

		PRINT_SPACE_LINE

		PRINT_MESSAGE	1Bh			; "Not enough"

		PRINT_MESSAGE	7Bh			; "gold"

		jp	go_change_speed
; -------------------------------------

ready_for_trade:
		PRINT_SPACE_LINE

		PRINT_IN_LOOP
		db  16h, 44h, 0FFh			; "To Who?"
									; "(1-6)"

		ENTER_1_TO_6

		ret	c
		push	ix

		FIND_HERO_BY_A

		push	ix
		pop	hl
		pop	ix
		ret	z

		ld	e, CHAR_GOLD_START
		call	decreas_12_digits
		push	ix
		push	hl
		pop	ix
		call	increas_12_digits
		pop	ix

		PRINT_SPACE_LINE

		PRINT_MESSAGE	1Ch			; "Done!"

		jr	go_change_speed
; -------------------------------------

check_is_equipped:
		cp	1
		jp	z, thats_equipped

		ld	a, (hl)
		and	0F0h
		ld	d, a
		inc	hl
		ld	a, (hl)
		or	a
		ret	z

		ld	e, a

		PRINT_SPACE_LINE

		PRINT_IN_LOOP
		db  16h, 44h, 0FFh			; "To Who?"
									; "(1-6)"

		ENTER_1_TO_6

		ret	c

		call	all_full
		ret	z

		jp	c, go_change_speed

		dec	hl

loc_72A4:
		ex	de, hl

		FIND_ATTR_AND_ADDRESS	CHAR_LASTITEM_STATE

		and	a
		sbc	hl, de
		ld	c, l
		push	de
		pop	hl
		ld	b, 0
		jr	z, loc_72B7

		inc	hl
		inc	hl
		ldir

		ex	de, hl

loc_72B7:
		ld	(hl), b
		inc	hl
		ld	(hl), b

		ret
; -------------------------------------

ascii_to_num:
		push	bc

		NULLIFY_FB5B

		pop	bc
		ld	hl, addr_FB5B
		ld	de, PARTY_HEADER
		ld	a, b

		cp	0Ch
		ccf
		ret	c

		add	a, e
		ld	e, a
		jr	nc, loop_ascii_to_num

		inc	d

loop_ascii_to_num:
		ld	a, (de)
		sub	'0'
		ret	c

		cp	0Ah
		ccf
		ret	c

		ld	(hl), a
		dec	hl
		dec	de
		djnz	loop_ascii_to_num

		ret
