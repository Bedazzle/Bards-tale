; --- get_cell_feature ($D30A-$D31A) ----------------------------
; @wip
; Return the MAZE_FEATURES byte for the party's current cell (+$1E4 plane).

get_cell_feature:
		push	de
		push	bc
		ld	bc,(var_5FAC)
		call	maze_cell_addr
		ld	de,$1e4
		add	hl,de
		ld	a,(hl)
		pop	bc
		pop	de
		ret
