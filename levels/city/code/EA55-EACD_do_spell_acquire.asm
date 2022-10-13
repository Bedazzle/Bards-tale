do_spell_acquire:
		CLEAR_INFO_PANEL

		PRINT_MESSAGE2	16h			; "Who seeks knowledge of the mystic arts (1-6)"

		call	is_a_spellcaster
		jp	nc, reset_reviewboard

		ld	c, a
		dec	a

		GET_A_FROM_TABLE	0Dh

		ld	b, a

		GET_ATTR_BY_A

		ld	e, a

		cp	7
		jr	c, loc_EA75

		PRINT2_IN_LOOP
		db  14h, 64h,0FFh			; "Thou art"
									; "at thy highest level of spell ability."

		jp	wait_reviewboard
; -------------------------------------

loc_EA75:
		GET_ATTR_BY_PARAM	CHAR_LEVEL_HI

		jr	nz, loc_EA8B

		inc	hl
		ld	a, (hl)
		inc	a
		srl	a

		cp	e
		jr	z, no_new_spells
		jr	nc, loc_EA8B

no_new_spells:
		PRINT2_IN_LOOP
		db  13h, 67h,0FFh			; "Thou cannot"
									; "acquire new spells yet."

		jr	loc_EAAE
; -------------------------------------

loc_EA8B:
		ld	a, c
		add	a, 87h

		PRINT_WORD

		PRINT_MESSAGE2	71h			; "spell level"

		ld	a, e

		PRINT_NEXT_DIGIT

		PRINT_MESSAGE2	72h			; "will cost thee"

		GET_E_FROM_TABLE	0Ch

		ld	e, CHAR_GOLD_START
		call	loc_77B0
		push	af
		call	loc_88E5
		pop	af
		jr	nc, ask_cost_in_gold

		PRINT2_IN_LOOP
		db  6Fh, 15h, 70h,0FFh		; "in gold."
									; "The Spell Sages"
									; "refuse to teach you until you can pay!"

loc_EAAE:
		jp	wait_reviewboard
; -------------------------------------

ask_cost_in_gold:
		PRINT2_IN_LOOP
		db  6Fh, 18h,0FFh			; "in gold."
									; "Will you pay"

		PRINT_YES_NO_WAIT

		jp	nc, reset_reviewboard

		call	decreas_12_digits

		CLEAR_INFO_PANEL

		PRINT_2_NEWLINES

		PRINT2_IN_LOOP
		db  15h, 63h,0FFh			; "The Spell Sages"
									; "have taught you the lore."

		ld	a, b

		GET_ATTR_BY_A

		inc	(hl)

		jp	wait_reviewboard
