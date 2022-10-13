print_letter_pair:
		push	bc
		ld	c, a

		GET_C_FROM_TABLE	INX_STATUSES

		PRINT_WITH_CODES

		inc	c

		GET_C_FROM_TABLE	INX_STATUSES

		pop	bc

		jp	prnt_with_codes
