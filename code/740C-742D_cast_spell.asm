cast_spell:
		call	who_cast_spell
		ret	c

		GET_IY_A_FROM_TABLE	4Bh, 69h

		and	7

		cp	4
		jr	nc, loc_7424

		push	af

		CLEAR_INFO_PANEL

		PRINT_MESSAGE	5			; "Cast at"

		pop	af

		RST_10_30

		ret	c

loc_7424:
		ld	(GAME_VARIABLES + VAR_53), a

		CLEAR_INFO_PANEL

		PRINT_IX_HERO_NAME

		jp	casts_a_spell
