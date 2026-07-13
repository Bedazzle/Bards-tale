; --- damage_groups_by_a ($D9C3-$D9D4) ----------------------------------
; @done
; Apply the damage amount in A to all 7 enemy groups (b=6..0 via apply_damage_to_group).

damage_groups_by_a:
		ld	l,a
		ld	h,0
		ld	(iy+$50),0
		ld	b,6
.loop:
		ld	a,b
		call	apply_damage_to_group
		dec	b
		jp	p,.loop
		ret
