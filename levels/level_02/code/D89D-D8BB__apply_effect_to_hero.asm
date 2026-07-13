; --- apply_effect_to_hero ----------------------------------
; @done
; Apply the current trap/encounter effect to party member B: store the raw value
; ($FB90), roll a save (CHECK_FLEE_RESULT); on a save halve it, then apply it to the
; hero via apply_damage_to_group. Returns the trap index ($5FE1).
; In: a = effect value, b = hero index.
apply_effect_to_hero:
		ld	(ACTIVE_GUARDIAN),a
		CHECK_FLEE_RESULT
		jr	c,.apply
		or	a
		jr	nz,.halve
		ld	hl,0
		ld	(damage_type),a
.halve:
		srl	h
		rr	l
.apply:
		ld	a,(damage_type)
		ld	a,b
		call	apply_damage_to_group
		ld	a,(treasure_flag)
		ret
