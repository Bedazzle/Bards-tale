sub_EBB4:
		ld	a, b
		add	a, (hl)
		ld	(hl), a
		dec	hl
		jr	nc, loc_EBBB

		inc	(hl)

loc_EBBB:
		dec	hl
		ld	a, b
		add	a, (hl)
		ld	(hl), a
		dec	hl
		ret	nc

		inc	(hl)

		ret
