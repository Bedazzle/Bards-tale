; --- damage_group_checked ($D9CF-$D9ED) ------------------------
; @done
; Set ACTIVE_GUARDIAN, run the flee check, then apply the rolled damage to group B.
; In:  a = guardian id, b = target group

damage_group_checked:
		ld	(ACTIVE_GUARDIAN),a
		CHECK_FLEE_RESULT
		jr	c,.apply		; fled -> full damage, skip the halving
		or	a
		jr	nz,.halve
		ld	hl,0
		ld	(damage_type),a
.halve:
		srl	h
		rr	l			; damage / 2
.apply:
		ld	a,(damage_type)
		ld	a,b
		call	apply_damage_to_group
		ld	a,(treasure_flag)
		ret
