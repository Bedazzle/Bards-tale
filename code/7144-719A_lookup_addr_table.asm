loc_7144:
		PUSH_REGS

		ld	b, 0
		call	get_param_to_A

loc_714B:
		cp	72h			; 114
		jr	c, calc_addr_from_A

		inc	bc

calc_addr_from_A:					; get address from table, A=position
		ld	l, a
		ld	h, 0
		add	hl, hl
		ld	de, ADDR_TABLE
		add	hl, de
		ld	e, (hl)
		inc	hl
		ld	d, (hl)
		ex	de, hl
		ld	(addr_table_index), a

		cp	67h 		; 103
		ld	a, 0FCh
		jr	nc, loc_7166

		xor	a

loc_7166:
		ex	af, af'

loc_7167:
		ld	a, b
		or	c
		jr	z, loc_7191

		ex	af, af'

loc_716C:
		ex	af, af'
		ld	a, 0FCh
		cpir
		jr	nz, loc_7191

		ld	a, (addr_table_index)

		cp	67h 		; 103
		jr	nc, loc_717E

		ld	a, c
		or	b
		jr	z, loc_7191

loc_717E:
		ex	af, af'

		cp	0FCh
		jr	nz, loc_716C

		ex	af, af'
		ld	a, c
		ld	c, (hl)
		dec	c
		sub	c
		inc	hl
		inc	hl
		ld	c, a
		jr	nc, loc_7167

		dec	b
		jp	p, loc_7167

loc_7191:
		dec	hl
		ld	a, (hl)
		push	hl
		exx
		pop	hl
		exx

		jp	test_A_copyB

; -------------------------------------
addr_table_index:
		db 0
