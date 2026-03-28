sub_EBAB:
		sub	0Eh
		jr	nc, loc_EBB0

		xor	a

loc_EBB0:
		add	a, b
		inc	a
		ld	b, a

		ret
