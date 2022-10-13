dummy_pause:
		ld	b, 0

loop_pause:
		djnz	$

		dec	c
		jr	nz, loop_pause

		ret
