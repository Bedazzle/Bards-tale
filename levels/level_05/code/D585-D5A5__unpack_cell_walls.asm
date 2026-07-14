; --- unpack_cell_walls ($D585-$D5A5) ----------------------------------
; @done

unpack_cell_walls:
		push	bc
		ld	bc,(view_y_offset)
		call	maze_cell_addr
		ld	l,a
		and	3
		ld	c,a
		ld	b,3
.loop:
		ld	a,l
		srl	a
		srl	a
		ld	l,a
		and	3
		push	af
		djnz	.loop
		pop	hl
		pop	af
		ld	e,a
		pop	af
		ld	d,a
		ld	l,c
		pop	bc
		ret
