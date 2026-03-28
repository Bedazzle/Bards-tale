dyn_proc_76:				; RST_10_45
		push	bc
		ld	e, a
		ld	c, 0

loc_877C:
		call	print_plus_minus

loc_877F:
		WAIT_KEY_DOWN

		cp	' '
		jr	z, loc_879D

		cp	CODE_C8
		jr	z, loc_8795

		cp	CODE_C9
		jr	nz, loc_877F
		ld	a, c

		cp	0EBh
		jr	z, loc_877F

		dec	c
		jr	loc_877C

loc_8795:
		ld	a, c

		cp	15h
		jr	z, loc_877F

		inc	c

		jr	loc_877C

loc_879D:
		ld	a, e
		bit	7, c
		jr	nz, loc_87AB

		add	a, c
		cp	16h
		jr	c, loc_87B0

		sub	16h

		jr	loc_87B0

loc_87AB:
		add	a, c
		jr	c, loc_87B0

		add	a, 16h

loc_87B0:
		inc	(iy+VAR_CURSOR_ROW)
		pop	bc

		ret
