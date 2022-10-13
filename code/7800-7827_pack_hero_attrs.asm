pack_hero_attrs:
		PUSH_REGS

		ld	b, 2
		ld	de, addr_FB5C

loop_pack_attrs:
		ld	a, (de)
		ld	h, a
		inc	de
		ld	a, (de)
		inc	de
		rla
		rla
		rla
		ld	l, a
		add	hl, hl
		add	hl, hl
		add	hl, hl
		ex	de, hl
		ld	a, e
		and	0C0h
		or	(hl)
		ld	e, a
		ex	de, hl
		ld	(ix+CHAR_PARAMS_HI), h
		ld	(ix+CHAR_PARAMS_LO), l
		inc	ix
		inc	ix
		inc	de
		djnz	loop_pack_attrs

		ret
