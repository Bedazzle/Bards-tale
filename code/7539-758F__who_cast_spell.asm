; --- who_cast_spell -----------------------------------------
; @done
; Field/dungeon "cast a spell" entry: asks which party member will
; cast, prompts for the 4-letter spell code, looks it up via
; process_spell, then validates that the hero actually knows the
; spell (class/level), that it may be cast outside combat, and that
; he can afford its spell-point cost before handing off to the
; caster. Rejects unknown or non-combat spells with a message.
; In:  iy = game variables base
; Out: carry set on any failure/abort (invalid, unknown, cancelled)
; Note: `ld (spell_result+2),a` self-modifies the message id printed
;       at spell_result; e/c are pre-loaded as spell class/level masks.
who_cast_spell:
		PRINT_WHO_WILL

		PRINT_MESSAGE	$52			; "cast a spell?"

		CHOOSE_HERO

		ret	c

		ld	a,$10
		ld	c,$22

cast_spell_by_e:
		PUSH_REGS

		ld	e,a
		ld	a,c
		ld	(spell_result+2),a

		PRINT_CRLF_AND_MESSAGE	4	; "Spell to cast:"

		call	enter_text
		ret	c

		PRINT_NEWLINE

		ld	a,b

		cp	4						; length of spell text
		jr	nz,invalid_spell

		call	process_spell
		jr	nc,unknown_spell

		PRINT_MESSAGE	6			; "Try again!"

		jr	exit_spell
; -------------------------------------

unknown_spell:
		ld	a,(GAME_VARIABLES + VAR_SPELL_CLASS)
		add	a,$40

		GET_ATTR_BY_A

		cp	(iy+VAR_SPELL_LEVEL)
		jr	nc,no_combat_spell

		PRINT_IN_LOOP
		DB 7,$47,$FF			; "Thou knowest not that"
									; "spell!"

		jr	exit_spell
; -------------------------------------

no_combat_spell:
		GET_IY_A_FROM_TABLE	$4B,$69

		and	e
		jr	nz,no_spell_points

spell_result:
		PRINT_MESSAGE	8			; "Not a combat spell!"

		jr	exit_spell
; -------------------------------------

no_spell_points:
		CHECK_SPELL_COST

		ret	nc

		PRINT_MESSAGE	$1B			; "Not enough"

		PRINT_MESSAGE	$5F			; "spell points!"

exit_spell:
		CHANGE_SPEED_TO_8

invalid_spell:
		scf

		ret
