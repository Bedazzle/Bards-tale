; --- move_party_forward ($DD09-$DD13) --------------------------
; @wip
; Reset combat flags then step the party one cell in the facing direction.

move_party_forward:
		ld	a,(iy+3)
		ld	(iy+$3d),0
		ld	(iy+$40),0
