dyn_proc_79:				; RST_10_48
		push	de

loc_888A:
		ld	d, 0

loc_888C:
		GET_RND_BY_PARAM	3

loc_888F:
		ld	e, a
		inc	e
		add	hl, de
		djnz	loc_888C

		pop	de

		ret
