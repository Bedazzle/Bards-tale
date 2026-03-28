sub_F1A9:
		ld	e, a

		GET_C_FROM_TABLE	8

		ld	d, a
		ld	hl, addr_F4A7
		add	a, l
		ld	l, a
		jr	nc, loc_F1B6
		inc	h

loc_F1B6:
		ld	a, (hl)
		inc	hl
		ld	h, (hl)
		ld	l, a
		ld	e, (hl)
		inc	hl
		ld	d, (hl)
		inc	hl
		ld	b, (hl)
		inc	hl

		GET_C_FROM_TABLE	7

		push	af

		GET_C_FROM_TABLE	5

		ld	c, a
		pop	af
		push	hl
		push	de
		ld	hl, 3EFFh

loc_F1CE:
		add	a, l
		ld	l, a
		jr	nc, loc_F1D3
		inc	h

loc_F1D3:
		ld	a, b
		call	divide_A_by_8
		ld	de, 20h

loc_F1DA:
		add	hl, de
		dec	a
		jp	p, loc_F1DA

		ld	a, b
		and	7
		ld	de, 100h

loc_F1E5:
		add	hl, de
		dec	a
		jp	p, loc_F1E5

		pop	de
		exx
		ld	b, 1
		pop	hl
		exx

loc_F1F0:
		ld	b, d
		inc	b
		push	hl
		push	de
		xor	a
		ex	af, af'

loc_F1F6:
		push	hl
		exx
		dec	b
		ld	a, c
		jr	nz, loc_F208

		ld	b, 1
		ld	a, (hl)
		dec	a
		jr	nz, loc_F206

		inc	hl
		ld	b, (hl)
		inc	hl
		ld	c, (hl)

loc_F206:
		ld	a, (hl)
		inc	hl

loc_F208:
		exx
		ld	e, a
		ld	d, 0
		dec	c
		inc	c
		jr	z, loc_F215

		ld	hl, addr_F6E7
		add	hl, de
		ld	e, (hl)

loc_F215:
		call	sub_F259
		cpl
		pop	hl
		and	(hl)
		or	e
		ld	(hl), a
		jr	z, loc_F222

		ex	af, af'
		inc	a
		ex	af, af'

loc_F222:
		inc	h
		ld	a, h
		and	7
		jr	nz, loc_F24A

		ex	af, af'
		cp	8
		jr	nz, loc_F23E

		push	hl
		dec	h
		ld	a, h
		rra
		rra
		rra
		rra
		ld	a, 58h ; 'X'
		adc	a, 0
		ld	h, a
		ld	a, (addr_5821)
		ld	(hl), a
		pop	hl

loc_F23E:
		xor	a
		ex	af, af'
		ld	a, l
		add	a, 20h ; ' '
		ld	l, a
		jr	c, loc_F24A

		ld	a, h
		sub	8
		ld	h, a

loc_F24A:
		djnz	loc_F1F6

		pop	de
		pop	hl
		dec	c
		inc	c
		jr	z, loc_F254

		dec	hl
		dec	hl

loc_F254:
		inc	hl
		dec	e
		jr	nz, loc_F1F0

		ret
