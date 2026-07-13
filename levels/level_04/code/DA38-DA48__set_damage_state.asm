; --- set_damage_state ($DA38-$DA48) ------------------------
; @done
; Set up the damage-state vars ($5FFB, iy+$52) and return the high nibble of $5FFF.
; In:  a = damage value (stored to $5FFB)
; Out: a = hi nibble of $5FFF

set_damage_state:
		ld	(damage_type),a
		ld	(iy+$52),$80
		ld	a,(copy_daypart)
		rla
		rla
		rla
		rla
		and	$F0
		ret
