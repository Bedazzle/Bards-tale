; --- wrap_view_ns ($D728-$D731) ----------------------------
; @done
; Wrap the N/S view coord ($5FE3) into 0..21.
; Wraps the N/S view coord ($5FE3) in place into 0..21

wrap_view_ns:
		ld	a,(view_y_offset)
		call	wrap_maze_coord
		ld	(view_y_offset),a
		ret
