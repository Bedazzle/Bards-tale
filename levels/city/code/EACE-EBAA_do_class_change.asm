do_class_change:
		CLEAR_INFO_PANEL

		PRINT_MESSAGE2	10h			; "Which mage seeks to change his class?"

		PRINT_MESSAGE	44h			; "(1-6)"

		PRINT_NEWLINE

		call	is_a_spellcaster
		jp	nc, reset_reviewboard

		dec	a

		GET_A_FROM_TABLE	0Dh

		GET_ATTR_BY_A

		cp	3						; minimal spell level
		jr	nc, try_class_change

no_spell_level:
		PRINT_MESSAGE2	11h			; "Thou must know at least 3 spell levels in your present art first."

jmp_wait_reviewboard:
		jp	wait_reviewboard
; -------------------------------------

try_class_change:
		CLEAR_INFO_PANEL

		PRINT_IX_HERO_NAME

		PRINT_NEWLINE

		call	print_magic_attrs

		PRINT_2_NEWLINES

		ld	b, 0
		ld	c, b

		FIND_ATTR_AND_ADDRESS	CHAR_SORC_LEVEL

loc_EAFF:
		ld	a, (hl)
		or	a
		jr	z, loc_EB12

		inc	b
		inc	c
		inc	hl
		ld	a, b

		cp	4
		jr	c, loc_EAFF

old_class:
		PRINT2_IN_LOOP
		db  13h, 66h,0FFh			; "Thou cannot"
									; "change to an old class!"

		jr	jmp_wait_reviewboard
; -------------------------------------

loc_EB12:
		ld	a, b

		cp	3
		jr	nz, loc_EB1C

		ld	a, c

		cp	2
		jr	c, loc_EB21

loc_EB1C:
		ld	a, b
		add	a, 8Eh

		PRINT2_A_WITH_FLAG_0

loc_EB21:
		inc	b
		inc	hl
		ld	a, b

		cp	4
		jr	z, loc_EB2F

		ld	a, (hl)
		or	a
		jr	z, loc_EB12

		inc	c

		jr	loc_EB21
; -------------------------------------

loc_EB2F:
		PRINT_2_NEWLINES

		PRINT_CRLF_AND_MESSAGE	48h			; "[ext] to abort"

loc_EB34:
		FIND_ATTR_AND_ADDRESS	CHAR_SORC_LEVEL

		WAIT_KEY_DOWN

		ld	d, 2

		cp	CODE_ABORT
		jp	z, reset_reviewboard

		cp	'S'				; sorcerer
		jr	z, loc_EB56

		inc	hl
		inc	d

		cp	'C'				; conjurer
		jr	z, loc_EB56

		inc	hl
		inc	d

		cp	'M'				; magician
		jr	z, loc_EB56

		inc	hl
		inc	d

		cp	'W'				; wizard
		jr	nz, loc_EB34

loc_EB56:
		ld	b, (hl)
		dec	b
		inc	b
		jr	nz, loc_EB34

		cp	'W'				; wizard
		jr	nz, loc_EB64

		ld	a, c

		cp	2
		jr	c, loc_EB34

loc_EB64:
		ld	(hl), 1
		ld	a, d

		cp	5
		jr	nz, reset_char_level

		ld	a, 1

reset_char_level:
		ld	(ix+CHAR_CLASS), a
		xor	a
		ld	(ix+CHAR_LEVEL_HI), a
		ld	(ix+CHAR_MAXLEVEL_HI), a
		inc	a
		ld	(ix+CHAR_LEVEL_LO), a
		ld	(ix+CHAR_MAXLEVEL_LO), a

		FIND_ATTR_AND_ADDRESS	CHAR_EXP_START

		ld	b, 0Ch					; 12 bytes

loc_EB83:
		ld	(hl), 0
		inc	hl
		djnz	loc_EB83

		PRINT_NEWLINE

		PRINT_MESSAGE	1Ch			; "Done!"

		jp	wait_reviewboard

; ======= S U B	R O U T	I N E =========


is_a_spellcaster:
		call	enter_hero_num
		jr	c, not_a_spellcaster

		GET_ATTR_BY_PARAM_SAVE_HL	CHAR_CLASS		; get hero class

		jr	z, no_spells

		cp	CLASS_ROGUE
		ret	c

no_spells:
		PRINT2_IN_LOOP
		db  14h, 65h,0FFh			; "Thou art"
									; "not a spell caster!"

		PRINT_AND_WAIT

not_a_spellcaster:
		and	a

		ret

; -------------------------------------

wait_reviewboard:
		PRINT_AND_WAIT

		jp	reset_reviewboard
