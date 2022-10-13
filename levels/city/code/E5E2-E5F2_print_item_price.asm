print_item_price:
		call	sub_E50D

		RESET_COL

		ld	(iy+VAR_CURSOR_ROW), 0Ch

loc_E5EB:
		PRINT_CRLF_AND_MESSAGE	32h			; "Gold :"

		ld	e, CHAR_GOLD_START

		jp	print_12_digits
