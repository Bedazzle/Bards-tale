; --- make_damage_spec --------------------------------------
; @done
; Prepare the effect/damage spec: store A ($5FFB), mark iy+$52, and return
; ($5FFF<<4)&$F0.
make_damage_spec:
		ld	(var_5FFB),a
		ld	(iy+$52),$80
		ld	a,(var_5FFF)
		rla
		rla
		rla
		rla
		and	$F0
		ret
