; --- wrap_maze_coord ($D6E8-$D6F3) -----------------------------
; @wip
; Clamp/wrap a maze coord into 0..$15 (21): <0 -> $15, >=$16 -> 0.

wrap_maze_coord:
		or	a
		jp	p,.d6ef
		ld	a,$15
		ret
.d6ef:
		cp	$16
		ret	c
		xor	a
		ret
