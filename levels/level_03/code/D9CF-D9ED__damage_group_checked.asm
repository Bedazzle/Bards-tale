; --- damage_group_checked ($D9CF-$D9ED) ------------------------
; @wip
; Set ACTIVE_GUARDIAN, run the flee check, then apply the rolled damage to group B.

damage_group_checked:
		ld	(ACTIVE_GUARDIAN),a
		CHECK_FLEE_RESULT
		jr	c,.d9e3
		or	a
		jr	nz,.d9df
		ld	hl,0
		ld	(var_5FFB),a
.d9df:
		srl	h
		rr	l
.d9e3:
		ld	a,(var_5FFB)
		ld	a,b
		call	apply_damage_to_group
		ld	a,(var_5FE1)
		ret
