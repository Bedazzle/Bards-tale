loc_88E5:
		push	bc
		ld	b, 0

loc_88E8:
		GET_B_FROM_TABLE	5Eh

		or	a
		jr	nz, loc_88F4

		inc	b
		ld	a, b

		cp	0Bh
		jr	c, loc_88E8

loc_88F4:
		ld	a, 0Bh
		sub	b
		add	a, (iy+VAR_CURSOR_COL)		; CURSOR_COL

		cp	29h 			; 41
		jr	c, loc_8900

		PRINT_NEWLINE

loc_8900:
		GET_B_FROM_TABLE	5Eh

		PRINT_DIGIT

		inc	b
		ld	a, b

		cp	0Ch
		jr	c, loc_8900

		pop	bc

		ret
