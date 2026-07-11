; --- wrap_view_we ------------------------------------------
; @done
; Wrap the render/view column ($5FE4) into 0..21 via wrap_maze_coord.
wrap_view_we:
		ld	a,(view_we)
		call	wrap_maze_coord
		ld	(view_we),a
		ret
