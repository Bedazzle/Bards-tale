a_plus_c_to_hl:
		add	a, c
		exx
		ld	(hl), a
		exx

		ret
