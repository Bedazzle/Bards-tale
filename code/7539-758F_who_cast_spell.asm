who_cast_spell:
		PRINT_WHO_WILL

		PRINT_MESSAGE	52h			; "cast a spell?"

		CHOOSE_HERO

		ret	c

		ld	a, 10h
		ld	c, 22h

loc_7545:
		PUSH_REGS

		ld	e, a
		ld	a, c
		ld	(spell_result+2), a

		PRINT_CRLF_AND_MESSAGE	4	; "Spell to cast:"

		call	enter_text
		ret	c

		PRINT_NEWLINE

		ld	a, b

		cp	4						; length of spell text
		jr	nz, invalid_spell

		call	process_spell
		jr	nc, unknown_spell

		PRINT_MESSAGE	6			; "Try again!"

		jr	exit_spell
; -------------------------------------

unknown_spell:
		ld	a, (GAME_VARIABLES + VAR_SPELL_CLASS)
		add	a, 40h

		GET_ATTR_BY_A

		cp	(iy+VAR_SPELL_LEVEL)
		jr	nc, no_combat_spell

		PRINT_IN_LOOP
		db    7, 47h, 0FFh			; "Thou knowest not that"
									; "spell!"

		jr	exit_spell
; -------------------------------------

no_combat_spell:
		GET_IY_A_FROM_TABLE	4Bh, 69h

		and	e
		jr	nz, no_spell_points

spell_result:
		PRINT_MESSAGE	8			; "Not a combat spell!"

		jr	exit_spell
; -------------------------------------

no_spell_points:
		RST_10_42

		ret	nc

		PRINT_MESSAGE	1Bh			; "Not enough"

		PRINT_MESSAGE	5Fh			; "spell points!"

exit_spell:
		CHANGE_SPEED_TO_8

invalid_spell:
		scf

		ret
