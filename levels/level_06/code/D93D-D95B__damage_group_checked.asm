; --- damage_group_checked ($D93D-$D95B) ----------------------------------
; @done
; Set ACTIVE_GUARDIAN, run the flee check, then apply the rolled damage to group B.
; In:  a = guardian id, b = target group

damage_group_checked:
		ld	(ACTIVE_GUARDIAN),a
		CHECK_FLEE_RESULT
		jr	c,.done
		or	a
		jr	nz,.skip
		ld	hl,0
		ld	(damage_type),a
.skip:
		srl	h
		rr	l
.done:
		ld	a,(damage_type)
		ld	a,b
		call	apply_damage_to_group
		ld	a,(treasure_flag)
		ret
