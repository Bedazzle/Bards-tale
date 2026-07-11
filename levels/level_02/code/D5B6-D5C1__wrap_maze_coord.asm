; --- wrap_maze_coord ---------------------------------------
; @done
; Wrap a signed maze coordinate into 0..21 (the 22x22 grid): negative -> 21,
; >= 22 -> 0, otherwise unchanged.
; In: a = coord.  Out: a = wrapped coord.
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
