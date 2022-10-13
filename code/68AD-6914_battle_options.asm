battle_options:						; loc_68AD
		PRINT_IX_HERO_NAME

		PRINT_MESSAGE	55h			; "has these options this battle round:"

		ld	(iy+VAR_CURSOR_ROW), 6

		GET_GAME_VARIABLE	VAR_5A		; ???

		jr	nz, option_party_attack

		IF_FB98_IS_ZERO

		jr	z, option_party_attack

		ld	a, (___table_84)
		or	a
		jr	z, option_party_attack

		ld	a, b

		cp	4
		jr	nc, option_party_attack

		inc	c

		PRINT_CRLF_AND_MESSAGE	49h			; "(A)ttack foes"

option_party_attack:
		PRINT_IN_LOOP
		db  34h, 35h, 0FFh					; "(P)arty attack"
											; "(D)efend"

		GET_ATTR_BY_PARAM	CHAR_SPPT_HI

		jr	nz, option_spell

		inc	hl
		ld	a, (hl)
		or	a
		jr	z, option_att_party

option_spell:
		PRINT_CRLF_AND_MESSAGE	4Ah			; "(C)ast spell"

		set	1, c

option_att_party:
		PRINT_CRLF_AND_MESSAGE	4Bh			; "(P)arty attack"

		GET_ATTR_BY_PARAM_SAVE_HL	CHAR_CLASS

		cp	CLASS_ROGUE
		jr	nz, check_is_bard

option_hide:
		PRINT_CRLF_AND_MESSAGE	4Ch			; "(H)ide in shadows"

		set	2, c
		jr	select_option

check_is_bard:
		cp	CLASS_BARD
		jr	nz, select_option

hero_is_bard:
		call	loc_6D05
		jr	c, select_option

		PRINT_CRLF_AND_MESSAGE	4Dh			; "(B)ard Song"

		set	3, c

select_option:
		PRINT_CRLF_AND_MESSAGE	2			; "Select option."

loop_option:
		WAIT_KEY_DOWN

		ld	hl, OPTION_KEYS
		ld	e, 7

search_option:
		cp	(hl)
		jr	z, option_is_found

		dec	hl
		dec	e
		jp	p, search_option

		jr	loop_option
