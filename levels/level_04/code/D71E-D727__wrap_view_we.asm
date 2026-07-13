; --- wrap_view_we ($D71E-$D727) ----------------------------
; @done
; Wrap the W/E view coord ($5FE4) into 0..21.
; Wraps the W/E view coord ($5FE4) in place into 0..21

wrap_view_we:
		ld	a,(view_x_offset)
		call	wrap_maze_coord
		ld	(view_x_offset),a
		ret
