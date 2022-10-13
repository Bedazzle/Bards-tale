remove_char:
		CLEAR_INFO_PANEL

		PRINT_MESSAGE2	30h			; "Enter the name of the character:"

		call	enter_text
		jr	c, abort_remove_char

		call	find_hero_by_name
		jr	c, loc_F404

		CLEAR_INFO_PANEL

		PRINT_MESSAGE2	31h			; "There's no character of that name in the party."

		PRINT_AND_WAIT

abort_remove_char:
		jp	proc_guild

loc_F404:
		dec	(iy+VAR_00)

loc_F407:
		ld	(ix+CHAR_STATUS), 3
		ld	(ix+CHAR_NEG_FLAG), 1
		call	loc_7967

		PRINT_STATS_TABLE

		jp	proc_guild
