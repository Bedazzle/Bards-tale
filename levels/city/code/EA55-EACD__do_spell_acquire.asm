; --- do_spell_acquire -----------------------------------------
; @done
; Review Board menu option "learn spells": pick a hero, verify he
; is a spellcaster, and if eligible sell him the next level of his
; magic art for gold. Paying bumps his spell-level count by one.
; In:  ix -> selected hero record (set by is_a_spellcaster)
; Note: capped at spell level 7, and blocked until the character
;       level is high enough ((level+1)/2 > current spell level).
do_spell_acquire:
		CLEAR_INFO_PANEL

		PRINT_MESSAGE2	$16			; "Who seeks knowledge of the mystic arts (1-6)"

		call	is_a_spellcaster
		jp	nc,reset_reviewboard

		ld	c,a
		dec	a

		GET_A_FROM_TABLE	$0D

		ld	b,a

		GET_ATTR_BY_A

		ld	e,a

		cp	7
		jr	c,.check_eligible

		PRINT2_IN_LOOP
		DB $14,$64,$FF			; "Thou art"
									; "at thy highest level of spell ability."

		jp	wait_reviewboard
; -------------------------------------

.check_eligible:
		GET_ATTR_BY_PARAM	CHAR_LEVEL_HI

		jr	nz,no_new_spells.offer_spell	; high char level -> can always advance

		inc	hl
		ld	a,(hl)
		inc	a
		srl	a

		cp	e
		jr	z,no_new_spells
		jr	nc,no_new_spells.offer_spell	; allowed level exceeds current -> advance

no_new_spells:
		PRINT2_IN_LOOP
		DB $13,$67,$FF			; "Thou cannot"
									; "acquire new spells yet."

		jr	.done
; -------------------------------------

.offer_spell:
		ld	a,c
		add	a,$87

		PRINT_WORD

		PRINT_MESSAGE2	$71			; "spell level"

		ld	a,e

		PRINT_NEXT_DIGIT

		PRINT_MESSAGE2	$72			; "will cost thee"

		GET_E_FROM_TABLE	$0C

		ld	e,CHAR_GOLD_START
		call	store_bcd_and_compare
		push	af
		call	print_large_number
		pop	af
		jr	nc,ask_cost_in_gold

		PRINT2_IN_LOOP
		DB $6F,$15,$70,$FF		; "in gold."
									; "The Spell Sages"
									; "refuse to teach you until you can pay!"

.done:
		jp	wait_reviewboard
; -------------------------------------

ask_cost_in_gold:
		PRINT2_IN_LOOP
		DB $6F,$18,$FF			; "in gold."
									; "Will you pay"

		PRINT_YES_NO_WAIT

		jp	nc,reset_reviewboard

		call	decreas_12_digits

		CLEAR_INFO_PANEL

		PRINT_2_NEWLINES

		PRINT2_IN_LOOP
		DB $15,$63,$FF			; "The Spell Sages"
									; "have taught you the lore."

		ld	a,b

		GET_ATTR_BY_A

		inc	(hl)

		jp	wait_reviewboard
