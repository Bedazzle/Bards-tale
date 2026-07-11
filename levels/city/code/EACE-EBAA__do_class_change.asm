; --- do_class_change ------------------------------------------
; @done
; Review Board menu option "change class": lets a magic-user who
; already knows at least 3 levels of his current art take on a new
; caster class (Sorcerer/Conjurer/Magician/Wizard). Lists the
; classes he may still choose, reads the pick, marks it known and
; resets the hero to level 1 with cleared experience.
; In:  ix -> selected hero record (set by is_a_spellcaster)
; Note: Wizard requires two other caster classes already held.
do_class_change:
		CLEAR_INFO_PANEL

		PRINT_MESSAGE2	$10			; "Which mage seeks to change his class?"

		PRINT_MESSAGE	$44			; "(1-6)"

		PRINT_NEWLINE

		call	is_a_spellcaster
		jp	nc,reset_reviewboard

		dec	a

		GET_A_FROM_TABLE	$0D

		GET_ATTR_BY_A

		cp	3						; minimal spell level
		jr	nc,try_class_change

no_spell_level:
		PRINT_MESSAGE2	$11			; "Thou must know at least 3 spell levels in your present art first."

jmp_wait_reviewboard:
		jp	wait_reviewboard
; -------------------------------------

try_class_change:
		CLEAR_INFO_PANEL

		PRINT_IX_HERO_NAME

		PRINT_NEWLINE

		call	print_magic_attrs

		PRINT_2_NEWLINES

		ld	b,0
		ld	c,b

		FIND_ATTR_AND_ADDRESS	CHAR_SORC_LEVEL

.count_classes:
		ld	a,(hl)
		or	a
		jr	z,old_class.consider_option	; empty slot -> hero can add a class

		inc	b
		inc	c
		inc	hl
		ld	a,b

		cp	4
		jr	c,.count_classes

old_class:
		PRINT2_IN_LOOP
		DB $13,$66,$FF			; "Thou cannot"
									; "change to an old class!"

		jr	jmp_wait_reviewboard
; -------------------------------------

.consider_option:
		ld	a,b

		cp	3
		jr	nz,.show_option

		ld	a,c

		cp	2
		jr	c,.next_slot

.show_option:
		ld	a,b
		add	a,$8E

		PRINT2_A_WITH_FLAG_0

.next_slot:
		inc	b
		inc	hl
		ld	a,b

		cp	4
		jr	z,.prompt_choice

		ld	a,(hl)
		or	a
		jr	z,.consider_option

		inc	c

		jr	.next_slot
; -------------------------------------

.prompt_choice:
		PRINT_2_NEWLINES

		PRINT_CRLF_AND_MESSAGE	$48			; "[ext] to abort"

.read_key:
		FIND_ATTR_AND_ADDRESS	CHAR_SORC_LEVEL

		WAIT_KEY_DOWN

		ld	d,2

		cp	CODE_ABORT
		jp	z,reset_reviewboard

		cp	'S'				; sorcerer
		jr	z,.check_slot

		inc	hl
		inc	d

		cp	'C'				; conjurer
		jr	z,.check_slot

		inc	hl
		inc	d

		cp	'M'				; magician
		jr	z,.check_slot

		inc	hl
		inc	d

		cp	'W'				; wizard
		jr	nz,.read_key

.check_slot:
		ld	b,(hl)
		dec	b
		inc	b
		jr	nz,.read_key

		cp	'W'				; wizard
		jr	nz,.apply

		ld	a,c

		cp	2
		jr	c,.read_key

.apply:
		ld	(hl),1
		ld	a,d

		cp	5
		jr	nz,reset_char_level

		ld	a,1

reset_char_level:
		ld	(ix+CHAR_CLASS),a
		xor	a
		ld	(ix+CHAR_LEVEL_HI),a
		ld	(ix+CHAR_MAXLEVEL_HI),a
		inc	a
		ld	(ix+CHAR_LEVEL_LO),a
		ld	(ix+CHAR_MAXLEVEL_LO),a

		FIND_ATTR_AND_ADDRESS	CHAR_EXP_START

		ld	b,$0C					; 12 bytes

.clear_exp:
		ld	(hl),0
		inc	hl
		djnz	.clear_exp

		PRINT_NEWLINE

		PRINT_MESSAGE	$1C			; "Done!"

		jp	wait_reviewboard

; ======= S U B	R O U T	I N E =========


; --- is_a_spellcaster -----------------------------------------
; @done
; Prompt for a party hero (1-6) and check whether he can cast
; spells.
; Out: CY set   = valid spellcaster chosen, a = hero number,
;                 ix -> hero record;
;      CY clear = aborted, or not a spellcaster (message shown).
is_a_spellcaster:
		call	enter_hero_num
		jr	c,not_a_spellcaster

		GET_ATTR_BY_PARAM_SAVE_HL	CHAR_CLASS		; get hero class

		jr	z,no_spells

		cp	CLASS_ROGUE
		ret	c

no_spells:
		PRINT2_IN_LOOP
		DB $14,$65,$FF			; "Thou art"
									; "not a spell caster!"

		PRINT_AND_WAIT

not_a_spellcaster:
		and	a

		ret

; -------------------------------------

; --- wait_reviewboard -----------------------------------------
; @done
; Shared exit for the Review Board actions: show the pending text,
; wait for a key, then drop back to the board menu.
wait_reviewboard:
		PRINT_AND_WAIT

		jp	reset_reviewboard
