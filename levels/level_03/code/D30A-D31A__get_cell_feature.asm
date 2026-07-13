; --- get_cell_feature ($D30A-$D31A) ----------------------------
; @done
; Return the MAZE_FEATURES byte for the party's current cell (+$1E4 plane).
; In:  ($5FAC)=N/S, ($5FAD)=W/E coord
; Out: a = feature byte at cell+$1E4

get_cell_feature:
		push	de
		push	bc
		ld	bc,(coord_so_no)		; party N/S + W/E coord
		call	maze_cell_addr
		ld	de,484			; skip to the parallel feature plane (22*22)
		add	hl,de
		ld	a,(hl)
		pop	bc
		pop	de
		ret
