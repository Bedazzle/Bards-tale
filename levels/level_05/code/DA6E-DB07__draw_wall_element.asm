; --- draw_wall_element ($DA6E-$DB07) ----------------------------------
; @done
; Blit one view element from the 5-byte-record table at $DD5F (stride $19).
; In:  b = view position, e = element index (into wall_element_table)

draw_wall_element:
		push	hl
		push	bc
		push	de
		ld	hl,$DC4E
		inc	b
		ld	de,5
.loop:
		add	hl,de
		djnz	.loop
		pop	de
		push	de
		ld	b,e
		inc	b
		ld	de,$19
.loop2:
		add	hl,de
		djnz	.loop2
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
		and	$1F
		ld	b,a
		inc	b
.loop3:
		ld	a,l
		add	a,$20
		ld	l,a
		jr	nc,.skip
		ld	a,h
		add	a,8
		ld	h,a
.skip:
		djnz	.loop3
		ld	a,d
		and	7
		ld	bc,$100
.loop4:
		add	hl,bc
		dec	a
		jp	p,.loop4
		push	hl
		exx
		pop	hl
		exx
		pop	bc
		pop	hl
		pop	de
		ex	af,af'
		ld	l,a
.loop5:
		push	hl
		exx
		push	hl
		exx
		inc	h
		ld	b,h
.loop6:
		ld	a,(de)
		inc	de
		ld	l,a
		dec	c
		inc	c
		jr	z,.skip2
		ld	h,$F2
		ld	a,(hl)
.skip2:
		exx
		or	(hl)
		ld	(hl),a
		inc	h
		ld	a,h
		and	7
		jr	nz,.skip3
		ld	a,l
		add	a,$20
		ld	l,a
		jr	c,.skip3
		ld	a,h
		sub	8
		ld	h,a
.skip3:
		exx
		djnz	.loop6
		exx
		pop	hl
		exx
		pop	hl
		dec	c
		inc	c
		exx
		jr	z,.skip4
		dec	hl
		jr	.done
.skip4:
		inc	hl
.done:
		exx
		dec	l
		jr	nz,.loop5
		pop	de
		pop	bc
		pop	hl
		ret
