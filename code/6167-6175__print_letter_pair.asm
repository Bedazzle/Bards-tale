; --- print_letter_pair ------------------------------------
; @done
; Print two consecutive characters from the INX_STATUSES table
; (indices A and A+1) via prnt_with_codes - e.g. a two-letter
; status abbreviation.
; In:  a = table index of the first character
; Note: preserves bc; the second character is printed by tail-call
;       to prnt_with_codes.
print_letter_pair:
		push	bc
		ld	c,a

		GET_C_FROM_TABLE	INX_STATUSES

		PRINT_WITH_CODES

		inc	c

		GET_C_FROM_TABLE	INX_STATUSES

		pop	bc

		jp	prnt_with_codes
