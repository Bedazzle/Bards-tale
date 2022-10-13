exec_for_heroes:
		push	hl
		call	get_param_to_A

		ld	l, a
		call	get_param_to_A

		ld	h, a
		ld	b, 6			; number of heros
		ld	(hero_function+1), hl
		pop	hl

loop_find_addr:
		FIND_HERO_BY_B

hero_function:
		call	nz, $		; !!! SMC
		djnz	loop_find_addr

		ret
