add_rnd_number:
		cp	0FFh
		ret	z

		ld	e, a

		GET_RND_BY_PARAM	0Fh

		inc	a
		add	a, e

		ret
