nullify_FDDD:
		ld	b, 7
		ld	hl, addr_FDDD

		jr	nullify_buffer

nullify_FB5B:
		ld	hl, addr_FB5B
		ld	b, 0Ch

nullify_buffer:
		xor	a

loop_nullify:
		ld	(hl), a
		dec	hl
		djnz	loop_nullify

		ret
