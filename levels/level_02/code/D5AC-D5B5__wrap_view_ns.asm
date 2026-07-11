; --- wrap_view_ns ------------------------------------------
; @done
; Wrap the render/view row ($5FE3) into 0..21 via wrap_maze_coord.
wrap_view_ns:
		ld	a,(view_ns)
		call	wrap_maze_coord
		ld	(view_ns),a
		ret
