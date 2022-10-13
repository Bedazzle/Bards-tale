prnt_space_line:
		push	bc
		push	hl
		push	de

		RESET_COL

		ld	b, 14h		; 20 dec

print_spaces:
		ld	a, 20h ; ' '
		push	bc
		call	print_A_symbol
		pop	bc
		inc	(iy+VAR_CURSOR_COL)
		djnz	print_spaces

		pop	de
		pop	hl
		pop	bc

		jr	reset_col
