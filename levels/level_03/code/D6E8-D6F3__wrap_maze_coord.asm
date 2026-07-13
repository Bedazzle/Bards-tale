; --- wrap_maze_coord ($D6E8-$D6F3) -----------------------------
; @done
; Clamp/wrap a maze coord into 0..$15 (21): <0 -> $15, >=$16 -> 0.
; In:  a = signed coord
; Out: a = wrapped into 0..21

wrap_maze_coord:
		or	a
		jp	p,.pos
		ld	a,21			; negative -> 21
		ret
.pos:
		cp	22
		ret	c			; 0..21 unchanged
		xor	a			; >= 22 -> 0
		ret
