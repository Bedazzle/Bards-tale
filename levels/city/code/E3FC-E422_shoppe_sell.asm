shoppe_sell:
		call	print_item_price

		PRINT_MESSAGE2	6	; "Sell item"

		PRINT_MESSAGE	45h	; "(1-8)"

		call	sub_E54C
		jr	c, loop_shoppe

		ld	c, e

loc_E40B:
		ld	e, CHAR_GOLD_START
		call	increas_12_digits

		GET_C_FROM_TABLE	16h

		cp	0FEh
		jr	nc, loc_E41A

		exx
		inc	(hl)
		exx

loc_E41A:
		dec	hl
		call	loc_72A4
		call	sub_75BF

		jr	shoppe_sell
