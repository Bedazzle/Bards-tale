print_12_digits:
		PUSH_REGS

		ld	a, e

		GET_ATTR_BY_A

		ld	b, 0Ch		; 12 digits

next_digit:
		ld	a, (hl)
		inc	hl
		or	a
		jr	nz, print_nonzero

		bit	7, e
		jr	nz, print_nonzero

		PRINT_SPACE

go_next_digit:
		djnz	next_digit

		ret

print_nonzero:
		PRINT_DIGIT

		ld	e, 0FFh

		jr	go_next_digit
