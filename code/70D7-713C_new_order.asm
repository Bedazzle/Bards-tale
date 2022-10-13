new_order:
		inc	(iy+VAR_PAUSE)		; pause ON

		GET_GAME_VARIABLE	VAR_00		; ???

		jr	c, loc_7139
		jr	z, loc_7139

		CLEAR_INFO_PANEL

		PRINT_MESSAGE	12h			; "New Order:"

		ld	hl, TEXT_BUFFER+5
		ld	b, 6
		ld	a, 36h ; '6'

fill_party_header:
		ld	(hl), a
		dec	a
		dec	hl
		djnz	fill_party_header

		ld	c, b

loc_70F3:
		ld	a, c

		PRINT_NEXT_DIGIT

		ld	a, '>'

		PRINT_WITH_CODES

loop_new_order:
		WAIT_KEY_DOWN

		ld	b, 5
		ld	e, a

loc_70FF:
		GET_B_FROM_TABLE	34h

		cp	e
		jr	z, loc_710B

		dec	b
		jp	p, loc_70FF

		jr	loop_new_order
; -------------------------------------

loc_710B:
		inc	b

		FIND_HERO_BY_B

		jr	z, loop_new_order

		GET_C_FROM_TABLE	34h

		dec	b

		GET_B_FROM_LIST	34h

		xor	a

		GET_C_FROM_LIST	34h

		PRINT_IX_HERO_NAME

		PRINT_NEWLINE

		push	ix
		pop	de
		ld	b, c
		inc	b

		FIND_HERO_BY_B

		push	ix
		pop	hl
		ld	a, 64h
		call	swap_byte_buffer
		ld	a, (GAME_VARIABLES)
		inc	c

		cp	c
		jr	z, loc_7137
		jr	nc, loc_70F3

loc_7137:
		PRINT_STATS_TABLE

loc_7139:
		dec	(iy+VAR_PAUSE)		; pause OFF

		ret
