decreas_12_digits:
		PUSH_REGS

		call	sub_7785
		ld	de, addr_FB5B

loc_7793:
		ld	b, 0Ch

loc_7795:
		ld	a, (hl)
		ex	de, hl
		sub	(hl)
		ex	de, hl
		ld	(hl), a
		jr	nc, loc_77AB

		push	hl
		ld	c, b

loc_779E:
		ld	a, (hl)
		add	a, 0Ah
		ld	(hl), a
		dec	hl
		dec	c
		jr	z, loc_77AA

		dec	(hl)

		jp	m, loc_779E

loc_77AA:
		pop	hl

loc_77AB:
		dec	hl
		dec	de
		djnz	loc_7795

		ret
