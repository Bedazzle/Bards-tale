; --- draw_wall_element -------------------------------------
; @done
; Blit one wall-element sprite of the 3D view. Looks the element record up in the
; wall-element table ($DC2D, stride 5 by position B) and a per-element sub-record
; (stride $19 by E), derives the sprite pointer + on-screen column/row, computes the
; ZX screen address ($4000 base) and OR-composites the sprite bytes (mask from the
; $F2xx plane). In: b = view position, e = element index.
draw_wall_element:
		push	hl
		push	bc
		push	de
		ld	hl,wall_element_table-$1E	; base for stride-5 index
		inc	b
		ld	de,5
.find_pos:
		add	hl,de
		djnz	.find_pos
		pop	de
		push	de
		ld	b,e
		inc	b
		ld	de,$19
.find_elem:
		add	hl,de
		djnz	.find_elem
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
		ld	hl,$4000		; SCREEN
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
.screen_down:
		ld	a,l
		add	a,$20
		ld	l,a
		jr	nc,.no_wrap
		ld	a,h
		add	a,8
		ld	h,a
.no_wrap:
		djnz	.screen_down
		ld	a,d
		and	7
		ld	bc,$100
.add_third:
		add	hl,bc
		dec	a
		jp	p,.add_third
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
.row_loop:
		ld	a,(de)
		inc	de
		ld	l,a
		dec	c
		inc	c
		jr	z,.have_byte
		ld	h,$F2			; sprite mask plane
		ld	a,(hl)
.have_byte:
		exx
		or	(hl)
		ld	(hl),a
		inc	h
		ld	a,h
		and	7
		jr	nz,.next_row
		ld	a,l
		add	a,$20
		ld	l,a
		jr	c,.next_row
		ld	a,h
		sub	8
		ld	h,a
.next_row:
		exx
		djnz	.row_loop
		exx
		pop	hl
		exx
		pop	hl
		dec	c
		inc	c
		exx
		jr	z,.step_up
		dec	hl
		jr	.step

.step_up:
		inc	hl
.step:
		exx
		dec	l
		jr	nz,.col_loop
		pop	de
		pop	bc
		pop	hl
		ret
