; --- set_damage_state ($D9EE-$D9FE) ----------------------------
; @done
; Set up the damage-state vars ($5FFB, iy+$52) and return the high nibble of $5FFF.
; In:  a = damage value (stored to $5FFB)
; Out: a = hi nibble of $5FFF

set_damage_state:
		ld	(damage_type),a		; stash the damage value
		ld	(iy+$52),$80		; set the "damage pending" flag

		ld	a,(copy_daypart)

		DUP 4
			rla			; low nibble -> high position
		EDUP

		and	$F0
		ret
