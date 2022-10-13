print_group:
		PRINT_MESSAGE	57h			; "group"

		ld	a, 2Dh 		; '-'

		jp	prnt_with_codes
