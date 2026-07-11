; --- dummy_pause ----------------------------------------------
; @done
; Busy-wait delay used to pace combat / message scrolling. Spins an
; inner 256-iteration djnz loop c times, doing no useful work.
; In:  c = number of outer passes (delay length)
; Note: returns with b = 0; a is preserved.
dummy_pause:
		ld	b,0

loop_pause:
		djnz	$

		dec	c
		jr	nz,loop_pause

		ret
