loc_78CC:
		GET_GAME_VARIABLE	VAR_UNDERGROUND

		jr	z, loc_78D7

		inc	(iy+VAR_35)
		call	sub_C19B

loc_78D7:
		jp	print_ellipsis
