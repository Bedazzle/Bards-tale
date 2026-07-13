; --- draw_wall_element ($DB7F-$DC18) ---------------------------
; @done
; Blit one view element from the 5-byte-record table at $DD5F (stride $19).
; In:  b = view position, e = element index (into wall_element_table)

draw_wall_element:
		push	hl
		push	bc
		push	de
		ld	hl,wall_element_table-$1E
		inc	b
		ld	de,5
.find_record:
		add	hl,de
		djnz	.find_record
		pop	de
		push	de
		ld	b,e
		inc	b
		ld	de,$19
.find_slot:
		add	hl,de
		djnz	.find_slot
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
		ld	hl,SCREEN
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
.row_loop:
		ld	a,l
		add	a,$20
		ld	l,a
		jr	nc,.row_next
		ld	a,h
		add	a,8
		ld	h,a
.row_next:
		djnz	.row_loop
		ld	a,d
		and	7
		ld	bc,$100
.pixel_rows:
		add	hl,bc
		dec	a
		jp	p,.pixel_rows
		push	hl
		exx
		pop	hl
		exx
		pop	bc
		pop	hl
		pop	de
		ex	af,af'
		ld	l,a
.col_loop:
		push	hl
		exx
		push	hl
		exx
		inc	h
		ld	b,h
.byte_loop:
		ld	a,(de)
		inc	de
		ld	l,a
		dec	c
		inc	c
		jr	z,.plot
		ld	h,high pixel_shift_table
		ld	a,(hl)
.plot:
		exx
		or	(hl)
		ld	(hl),a
		inc	h
		ld	a,h
		and	7
		jr	nz,.row_adv
		ld	a,l
		add	a,$20
		ld	l,a
		jr	c,.row_adv
		ld	a,h
		sub	8
		ld	h,a
.row_adv:
		exx
		djnz	.byte_loop
		exx
		pop	hl
		exx
		pop	hl
		dec	c
		inc	c
		exx
		jr	z,.col_fwd
		dec	hl
		jr	.col_done
.col_fwd:
		inc	hl
.col_done:
		exx
		dec	l
		jr	nz,.col_loop
		pop	de
		pop	bc
		pop	hl
		ret
