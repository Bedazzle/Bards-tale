print_hero_stats:
		FIND_HERO_BY_A

		ret	z

		GET_ATTR_BY_PARAM_SAVE_HL	CHAR_CLASS

		GET_A_FROM_TABLE	33h

		ld	b, 91h						; text: Party

		SHOW_NAME_PIC_AB

		PRINT_IX_HERO_NAME

		PRINT_CRLF_AND_MESSAGE	2Eh		; "Race"

		GET_ATTR_BY_PARAM_SAVE_HL	CHAR_RACE

		add	a, 80h

		PRINT_WORD

		PRINT_CRLF_AND_MESSAGE	2Fh		; "Class:"

		GET_ATTR_BY_PARAM_SAVE_HL	CHAR_CLASS

		add	a, 87h

		PRINT_WORD

		PRINT_NEWLINE

		call	unpack_hero_attrs
		call	print_hero_attrib

		RESET_COL

		PRINT_CRLF_AND_MESSAGE	30h		; "Lvl:"

		GET_ATTR_BY_PARAM	CHAR_LEVEL_HI

		call	sub_7221
		ld	(iy+VAR_CURSOR_COL), 1Dh	; 29

		PRINT_MESSAGE	13h				; "SpPt:"

		GET_ATTR_BY_PARAM	CHAR_SPPT_MAX_HI

		call	sub_7221

		PRINT_NEWLINE

		PRINT_CRLF_AND_MESSAGE	31h		; "Exper:"

		ld	e, CHAR_EXP_START
		call	print_12_digits

		PRINT_CRLF_AND_MESSAGE	32h		; "Gold :"

		ld	e, CHAR_GOLD_START
		call	print_12_digits

		PRINT_AND_WAIT

		cp	CODE_ABORT
		ret	z

loc_720A:
		RESET_ROW_COL

		call	print_hero_items
		call	print_magic_attrs

		PRINT_MESSAGE	14h				; "Choose: [E,T,D,P]"

loc_7215:
		ld	a, 4
		ld	c, 0
		call	loc_73A6
		jr	nc, loc_720A
		jr	nz, loc_7215

		ret

; -------------------------------------

sub_7221:
		ld	d, a
		inc	hl
		ld	e, (hl)

		jp	print_num_from_DE
