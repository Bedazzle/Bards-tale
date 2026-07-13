; --- wrap_view_we ($D6D4-$D6DD) --------------------------------
; @wip
; Wrap the W/E view coord ($5FE4) into 0..21.

wrap_view_we:
		ld	a,(var_5FE4)
		call	wrap_maze_coord
		ld	(var_5FE4),a
		ret
