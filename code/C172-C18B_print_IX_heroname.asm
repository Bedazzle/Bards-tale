print_IX_heroname:
		PUSH_REGS

		ld	hl, sentence
		ld	b, 1

next_letter:
		ld	a, (ix+CHAR_NAME)
		ld	(hl), a
		inc	hl
		inc	ix

		cp	0FFh		; name terminator
		jr	z, print_from_buffer

		cp	' '
		jr	z, next_column

		ld	d, b

next_column:
		inc	b

		jr	next_letter
