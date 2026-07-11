; --- spend_spell_points --------------------------------------
; @done
; Deducts the cost of the spell being cast from the active hero's
; spell points. Looks up the cost via CHECK_SPELL_COST (returns carry
; and bails if the hero cannot pay); if the hero has the relevant
; equipment (CHECK_EQUIPPED 4) the cost is halved. Subtracts the cost
; from the hero's 16-bit CHAR_SPPT pool.
; In:  iy = game variables base
; Out: carry set if the spell could not be paid for
spend_spell_points:
		ld	b,(iy+VAR_ACTIVE_HERO)

		FIND_HERO_BY_B

		CHECK_SPELL_COST

		ret	c

		ld	c,a

		CHECK_EQUIPPED	4

		jr	c,decrease_spell_points

		srl	c

decrease_spell_points:
		GET_ATTR_BY_PARAM	CHAR_SPPT_LO

		sub	c
		ld	(hl),a
		dec	hl
		ret	nc

		dec	(hl)
		and	a

		ret
