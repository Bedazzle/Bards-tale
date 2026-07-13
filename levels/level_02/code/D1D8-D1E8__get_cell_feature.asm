; --- get_cell_feature --------------------------------------
; @done
; Return the MAZE_FEATURES byte for the party's current cell.
; ; In:  ($5FAC)=N/S, ($5FAD)=W/E coord.  Out: a = feature byte at cell+$1E4.
get_cell_feature:
		push	de
		push	bc
		ld	bc,(coord_so_no)
		call	maze_cell_addr
		ld	de,$1e4
		add	hl,de
		ld	a,(hl)
		pop	bc
		pop	de
		ret
