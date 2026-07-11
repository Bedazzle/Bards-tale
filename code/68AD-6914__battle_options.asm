; --- battle_options -----------------------------------------
; @done
; Builds and displays the combat action menu for the current hero and
; waits for a valid key. Prints the options available to that hero this
; round - (A)ttack foes (only when ambushing a guardian and the hero is
; front-rank), (P)arty attack, (D)efend, (C)ast spell (if the hero has
; spell points), (H)ide in shadows (Rogue), (B)ard Song (Bard with a
; usable instrument) - building an availability mask in c. Reads a key,
; matches it against OPTION_KEYS, and hands the matched index to
; option_is_found.
; In:  ix = hero record, b = party slot, iy = game variables base
; Out: falls through to option_is_found with the chosen option
; Note: c = bitmask of which extra options (spell/hide/bard) are allowed.
battle_options:						; loc_68AD
		PRINT_IX_HERO_NAME

		PRINT_MESSAGE	$55			; "has these options this battle round:"

		ld	(iy+VAR_CURSOR_ROW),6

		GET_GAME_VARIABLE	VAR_AMBUSH_FLAG		; ???

		jr	nz,option_party_attack

		IF_FB98_IS_ZERO

		jr	z,option_party_attack

		ld	a,(ACTIVE_GUARDIAN)
		or	a
		jr	z,option_party_attack

		ld	a,b

		cp	4
		jr	nc,option_party_attack

		inc	c

		PRINT_CRLF_AND_MESSAGE	$49			; "(A)ttack foes"

option_party_attack:
		PRINT_IN_LOOP
		DB $34,$35,$FF					; "(P)arty attack"
											; "(D)efend"

		GET_ATTR_BY_PARAM	CHAR_SPPT_HI

		jr	nz,option_spell

		inc	hl
		ld	a,(hl)
		or	a
		jr	z,option_att_party

option_spell:
		PRINT_CRLF_AND_MESSAGE	$4A			; "(C)ast spell"

		set	1,c

option_att_party:
		PRINT_CRLF_AND_MESSAGE	$4B			; "(P)arty attack"

		GET_ATTR_BY_PARAM_SAVE_HL	CHAR_CLASS

		cp	CLASS_ROGUE
		jr	nz,check_is_bard

option_hide:
		PRINT_CRLF_AND_MESSAGE	$4C			; "(H)ide in shadows"

		set	2,c
		jr	select_option

check_is_bard:
		cp	CLASS_BARD
		jr	nz,select_option

hero_is_bard:
		call	find_special_weapon
		jr	c,select_option

		PRINT_CRLF_AND_MESSAGE	$4D			; "(B)ard Song"

		set	3,c

select_option:
		PRINT_CRLF_AND_MESSAGE	2			; "Select option."

loop_option:
		WAIT_KEY_DOWN

		ld	hl,OPTION_KEYS
		ld	e,7

search_option:
		cp	(hl)
		jr	z,option_is_found

		dec	hl
		dec	e
		jp	p,search_option

		jr	loop_option
