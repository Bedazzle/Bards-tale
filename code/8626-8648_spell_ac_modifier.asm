loc_8626:
		GET_B_FROM_TABLE	20h

		bit	7, (iy+VAR_ACTIVE_HERO)
		jr	z, loc_8636

		ld	hl, GAME_VARIABLES + VAR_62
		add	a, (hl)
		ld	(hl), a

		jr	loc_8647

loc_8636:
		ld	c, a
		ld	a, (GAME_VARIABLES + VAR_53)
		and	7Fh
		ld	b, a

		GET_B_FROM_TABLE	2Dh

		A_PLUS_C_TO_HL

		GET_B_FROM_TABLE	55h

		A_PLUS_C_TO_HL

loc_8647:
		jr	jp_print_ellipsis
