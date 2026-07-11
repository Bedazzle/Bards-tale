; --- print_hero_stats ----------------------------------------
; @done
; Draw a party member's full character sheet: name + portrait, race,
; class, base attributes, level, spell points, experience, gold,
; carried items and magic-class levels. Then run the [E,T,D,P] action
; menu, dispatching each key through process_action_key.
; In:  a = hero index (party slot)
; Note: returns early when the player presses the abort key.
print_hero_stats:
		FIND_HERO_BY_A

		ret	z

		GET_ATTR_BY_PARAM_SAVE_HL	CHAR_CLASS

		GET_A_FROM_TABLE	$33

		ld	b,$91						; text: Party

		SHOW_NAME_PIC_AB

		PRINT_IX_HERO_NAME

		PRINT_CRLF_AND_MESSAGE	$2E		; "Race"

		GET_ATTR_BY_PARAM_SAVE_HL	CHAR_RACE

		add	a,$80

		PRINT_WORD

		PRINT_CRLF_AND_MESSAGE	$2F		; "Class:"

		GET_ATTR_BY_PARAM_SAVE_HL	CHAR_CLASS

		add	a,$87

		PRINT_WORD

		PRINT_NEWLINE

		call	unpack_hero_attrs
		call	print_hero_attrib

		RESET_COL

		PRINT_CRLF_AND_MESSAGE	$30		; "Lvl:"

		GET_ATTR_BY_PARAM	CHAR_LEVEL_HI

		call	print_word_stat
		ld	(iy+VAR_CURSOR_COL),$1D	; 29

		PRINT_MESSAGE	$13				; "SpPt:"

		GET_ATTR_BY_PARAM	CHAR_SPPT_MAX_HI

		call	print_word_stat

		PRINT_NEWLINE

		PRINT_CRLF_AND_MESSAGE	$31		; "Exper:"

		ld	e,CHAR_EXP_START
		call	print_12_digits

		PRINT_CRLF_AND_MESSAGE	$32		; "Gold :"

		ld	e,CHAR_GOLD_START
		call	print_12_digits

		PRINT_AND_WAIT

		cp	CODE_ABORT
		ret	z

.show_actions:
		RESET_ROW_COL

		call	print_hero_items
		call	print_magic_attrs

		PRINT_MESSAGE	$14				; "Choose: [E,T,D,P]"

.read_action:
		ld	a,4
		ld	c,0
		call	process_action_key
		jr	nc,.show_actions
		jr	nz,.read_action

		ret

; -------------------------------------

; --- print_word_stat -----------------------------------------
; @done
; Print a 16-bit character attribute as a decimal number: high byte
; taken from a, low byte from (hl+1).
; In:  a = attribute high byte, hl -> attribute high byte
print_word_stat:
		ld	d,a
		inc	hl
		ld	e,(hl)

		jp	print_num_from_DE
