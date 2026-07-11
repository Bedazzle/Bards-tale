; --- check_spell_cost --------------------------------------------
; @done
; CHECK_SPELL_COST handler: tests whether the chosen hero has enough
; spell points to pay for the current spell. Reads the spell's cost
; from table $4B/$65 and compares it with the hero's spell-point
; attribute (CHAR_SPPT).
; In:  ix = hero record, iy = game variables base
; Out: carry set = not enough spell points; a = spell cost
; Note: entered via the CHECK_SPELL_COST macro.
check_spell_cost:						; CHECK_SPELL_COST
		GET_ATTR_BY_PARAM	CHAR_SPPT_HI

		jr	nz,.enough

		inc	hl

		GET_IY_A_FROM_TABLE	$4B,$65

		cp	(hl)
		jr	z,.enough

		ccf

		ret

.enough:
		GET_IY_A_FROM_TABLE	$4B,$65

		and	a

		ret
