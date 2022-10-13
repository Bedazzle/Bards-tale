fight_or_run:
		ld	(iy+VAR_51), 0

		GET_GAME_VARIABLE	VAR_5A			; ???

		jr	nz, party_fight

		RST_10_2F

		jr	c, party_fight

		PRINT_CRLF_AND_MESSAGE	0			; "Will you stalwart band (F)ight or (R)un?"

loop_run_fight:
		WAIT_KEY_DOWN

		cp	'F'
		jr	z, party_fight

		cp	'R'
		jr	nz, loop_run_fight

party_run:
		call	loc_7940
		jr	c, loc_687D
		jr	nz, loc_687D

loc_6879:
		inc	(iy+VAR_51)

		ret
; -------------------------------------

loc_687D:
		GET_RND_BY_PARAM	7

		jr	z, loc_6879

		GET_GAME_VARIABLE	VAR_UNDERGROUND

		jr	nz, party_fight

		GET_GAME_VARIABLE	VAR_DAY_PART

		jr	nz, party_fight

		GET_RND_BY_PARAM	3

		jr	z, loc_6879

party_fight:
		call	nullify_FDDD
		ld	b, 1

loc_6896:
		ld	c, 0

		CLEAR_INFO_PANEL

		FIND_HERO_BY_B

		jp	z, loc_69E3

		CHECK_HERO_STATUS

		jr	nc, loc_68AA
		jr	z, battle_options

		ld	a, 8

		GET_B_FROM_LIST	56h

loc_68AA:
		jp	loc_69D2
