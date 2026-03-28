loc_86AA:
		GET_B_FROM_TABLE	5Ch

		ld	c, a

		GET_GAME_VARIABLE	VAR_ACTIVE_HERO

		ld	a, (GAME_VARIABLES + VAR_53)
		jr	nc, loc_86BD

		and	7Fh

		GET_A_FROM_TABLE	2Ch

		jr	loc_86C0

loc_86BD:
		GET_A_FROM_TABLE	30h

loc_86C0:
		A_PLUS_C_TO_HL

jp_print_ellipsis:
		jp	print_ellipsis
