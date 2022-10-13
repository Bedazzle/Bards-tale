shoppe_identify:
		call	print_item_price

		PRINT_MESSAGE2	7			; "Identify"

		PRINT_MESSAGE	45h			; "(1-8)"

		call	sub_E54C
		jr	c, loop_shoppe

		ld	e, CHAR_GOLD_START
		call	check_12_digits
		jr	nc, do_identify

		PRINT_SPACE_LINE

		PRINT_MESSAGE	1Bh			; "Not enough"

		PRINT_MESSAGE	7Bh			; "gold"

		CHANGE_SPEED 0Ah

		jr	shoppe_identify

do_identify:
		ld	e, CHAR_GOLD_START
		call	decreas_12_digits
		dec	hl
		ld	a, (hl)
		and	0Fh
		ld	(hl), a

		jr	shoppe_identify
