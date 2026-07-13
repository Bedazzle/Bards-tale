; --- wrap_view_ns ($D6DE-$D6E7) --------------------------------
; @wip
; Wrap the N/S view coord ($5FE3) into 0..21.

wrap_view_ns:
		ld	a,(var_5FE3)
		call	wrap_maze_coord
		ld	(var_5FE3),a
		ret
