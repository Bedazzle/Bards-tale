; --- render_wall_flags ($D701-$D71D) -----------------------
; @done

render_wall_flags:
		push	bc
		ld	bc,(view_y_offset)
		call	maze_cell_addr
		ld	de,$1E4
		add	hl,de
		ld	a,(hl)
		and	$20
		push	af
		ld	a,(hl)
		and	$40
		pop	hl
		pop	bc
		GET_B_FROM_LIST $1D
		ld	a,h
		GET_B_FROM_LIST $1C
		ret
