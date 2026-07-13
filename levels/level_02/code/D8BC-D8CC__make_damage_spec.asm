; --- make_damage_spec --------------------------------------
; @done
; Prepare the effect/damage spec: store A ($5FFB), mark iy+$52, and return
; ($5FFF<<4)&$F0.
make_damage_spec:
		ld	(damage_type),a
		ld	(iy+$52),$80
		ld	a,(copy_daypart)
		rla
		rla
		rla
		rla
		and	$F0
		ret
