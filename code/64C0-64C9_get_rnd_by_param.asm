get_rnd_by_param:
		push	de

		call	get_param_to_A

		ld	e, a

		GET_RND_NUMBERS

		and	e
		pop	de

		ret
