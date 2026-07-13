; --- set_damage_state ($D9EE-$D9FE) ----------------------------
; @wip
; Set up the damage-state vars ($5FFB, iy+$52) and return the high nibble of $5FFF.

set_damage_state:
		ld	(var_5FFB),a
		ld	(iy+$52),$80
		ld	a,(var_5FFF)
		rla
		rla
		rla
		rla
		and	$f0
		ret
