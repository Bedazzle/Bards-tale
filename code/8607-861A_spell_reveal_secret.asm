loc_8607:
		GET_GAME_VARIABLE	VAR_UNDERGROUND

		jr	z, loc_8618

		ld	a, (CITY_MAP_DATA+26Ah)
		or	a
		jr	nz, loc_8618

		ld	(SPELL_SECRET_STATE), a
		inc	(iy+VAR_REVEAL_FLAG)

loc_8618:
		jp	print_ellipsis
