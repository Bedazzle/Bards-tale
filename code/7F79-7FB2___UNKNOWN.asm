loc_7F79:
		push	af

		RST_10_2E

		ld	c, b
		ld	de, 0
		ld	b, d

loc_7F81:
		and	a
		sbc	hl, bc
		jr	nc, loc_7F8C

		dec	(iy+VAR_45)
		jp	m, loc_7F92

loc_7F8C:
		inc	de
		ld	a, d

		cp	0FFh
		jr	nz, loc_7F81

loc_7F92:
		xor	a
		or	d
		or	e
		jr	nz, loc_7F98

		inc	de

loc_7F98:
		call	loc_5C17
		pop	af
		ld	e, a
		ld	b, c

loc_7F9E:
		FIND_HERO_BY_B

		call	increas_12_digits
		ld	a, e

		cp	14h
		jr	nz, loc_7FB0

		FIND_ATTR_AND_ADDRESS	CHAR_WON_COMBATS_LO

		inc	(hl)
		dec	hl
		jr	nz, loc_7FB0

		inc	(hl)

loc_7FB0:
		djnz	loc_7F9E

		ret
