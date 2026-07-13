; --- draw_wall_element ($DB7F-$DC18) ---------------------------
; @wip
; Blit one view element from the 5-byte-record table at $DD5F (stride $19).

draw_wall_element:
		push	hl
		push	bc
		push	de
		ld	hl,wall_element_table-$1e
		inc	b
		ld	de,5
.db89:
		add	hl,de
		djnz	.db89
		pop	de
		push	de
		ld	b,e
		inc	b
		ld	de,$19
.db93:
		add	hl,de
		djnz	.db93
		ld	c,(hl)
		srl	c
		srl	c
		srl	c
		dec	c
		inc	hl
		ld	e,(hl)
		inc	hl
		ld	d,(hl)
		inc	hl
		ld	a,(hl)
		inc	hl
		ld	h,(hl)
		ld	l,a
		ld	a,(hl)
		inc	hl
		ld	b,(hl)
		inc	hl
		inc	hl
		push	hl
		push	bc
		push	de
		ld	hl,$4000
		ld	b,0
		add	hl,bc
		ex	af,af'
		ld	a,d
		rra
		rra
		rra
		and	$1f
		ld	b,a
		inc	b
.dbbe:
		ld	a,l
		add	a,$20
		ld	l,a
		jr	nc,.dbc8
		ld	a,h
		add	a,8
		ld	h,a
.dbc8:
		djnz	.dbbe
		ld	a,d
		and	7
		ld	bc,$100
.dbd0:
		add	hl,bc
		dec	a
		jp	p,.dbd0
		push	hl
		exx
		pop	hl
		exx
		pop	bc
		pop	hl
		pop	de
		ex	af,af'
		ld	l,a
.dbde:
		push	hl
		exx
		push	hl
		exx
		inc	h
		ld	b,h
.dbe4:
		ld	a,(de)
		inc	de
		ld	l,a
		dec	c
		inc	c
		jr	z,.dbee
		ld	h,$f4
		ld	a,(hl)
.dbee:
		exx
		or	(hl)
		ld	(hl),a
		inc	h
		ld	a,h
		and	7
		jr	nz,.dc01
		ld	a,l
		add	a,$20
		ld	l,a
		jr	c,.dc01
		ld	a,h
		sub	8
		ld	h,a
.dc01:
		exx
		djnz	.dbe4
		exx
		pop	hl
		exx
		pop	hl
		dec	c
		inc	c
		exx
		jr	z,.dc10
		dec	hl
		jr	.dc11
.dc10:
		inc	hl
.dc11:
		exx
		dec	l
		jr	nz,.dbde
		pop	de
		pop	bc
		pop	hl
		ret
