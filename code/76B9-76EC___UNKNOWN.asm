loc_76B9:
		ld	b, (ix+CHAR_CLASS)
		inc	b
		ld	a, 0F3h

loc_76BF:
		add	a, 0Dh
		djnz	loc_76BF

		ld	de, 0Dh
		and	a
		sbc	hl, de
		jr	c, loc_76E3

		add	a, 0Ch

		GET_A_FROM_TABLE	49h

		call	loc_77B0
		inc	hl

loc_76D4:
		ld	a, 15h
		call	loc_771C
		dec	hl
		ld	a, l
		or	h
		jr	nz, loc_76D4

		ld	e, CHAR_EXP_START

		jp	check_12_digits

loc_76E3:
		add	hl, de
		add	a, l

		GET_A_FROM_TABLE	49h

		ld	e, 14h

		jp	loc_77B0
