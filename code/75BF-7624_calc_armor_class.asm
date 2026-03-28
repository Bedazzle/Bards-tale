sub_75BF:
		ld	e, 0
		call	loc_75C7

		jp	print_stats_table

loc_75C7:
		PUSH_REGS

		ld	a, (ix+CHAR_PARAMS_LO)
		and	1Fh
		sub	0Fh
		jr	c, loc_75D4

		add	a, e
		ld	e, a

loc_75D4:
		ld	a, (ix+CHAR_CLASS)			; Char Class

		cp	CLASS_PARTY
		jr	nc, loc_761B

		cp	CLASS_MONK
		jr	nz, loc_75EE

		GET_ATTR_BY_PARAM	CHAR_MAXLEVEL_HI

		jr	nz, loc_7615

		inc	hl
		ld	a, (hl)
		add	a, e
		jr	c, loc_7615

		cp	15h
		jr	nc, loc_7615

		ld	e, a

loc_75EE:
		FIND_ATTR_AND_ADDRESS	CHAR_INVENTORY

		ld	b, 8

loc_75F3:
		ld	a, (hl)

		cp	1
		inc	hl
		jr	nz, loc_7600

		ld	a, (hl)

		RST_10_61	73h, 0Fh

		add	a, e
		ld	e, a

loc_7600:
		inc	hl
		djnz	loc_75F3

loc_7603:
		RST_10_00	55h

		inc	hl
		add	a, (hl)
		inc	hl
		add	a, (hl)
		add	a, e
		sub	(iy+VAR_63)
		jr	nc, loc_7611

		xor	a

loc_7611:
		cp	15h
		jr	c, loc_7617

loc_7615:
		ld	a, 15h

loc_7617:
		ld	(ix+CHAR_NATURAL_AC), a

		ret
; -------------------------------------

loc_761B:
		ld	a, (ix+CHAR_16)

		RST_10_61	44h, 1Fh

		ld	e, a

		jr	loc_7603
