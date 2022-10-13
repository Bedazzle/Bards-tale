swap_byte_buffer:
		PUSH_REGS

		ld	b, a

loop_swap:
		ld	a, (de)
		ld	c, (hl)
		ld	(hl), a
		ld	a, c
		ld	(de), a
		inc	hl
		inc	de
		djnz	loop_swap

		ret
