; --- wrap_maze_coord ($D732-$D73D) -------------------------
; @done
; Clamp/wrap a maze coord into 0..$15 (21): <0 -> $15, >=$16 -> 0.
; In:  a = signed coord
; Out: a = wrapped into 0..21

wrap_maze_coord:
		or	a
		jp	p,.done
		ld	a,$15
		ret
.done:
		cp	$16
		ret	c
		xor	a
		ret
