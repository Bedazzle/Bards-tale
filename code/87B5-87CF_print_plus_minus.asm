print_plus_minus:
		PUSH_REGS

		ld	(iy+VAR_CURSOR_COL), 1Ch	; 28
		bit	7, c
		ld	a, '+'
		jr	z, print_sign

		ld	a, '-'

print_sign:
		PRINT_WITH_CODES

		ld	a, c

		cp	16h
		jr	c, print_as_is

		neg

print_as_is:
		ld	e, a

		jp	print_num_from_E
