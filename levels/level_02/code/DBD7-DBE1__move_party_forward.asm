; --- move_party_forward ------------------------------------
; @done
; Clear the per-move flags (iy+$3D, iy+$40), then step the party one cell in the
; current facing (iy+3). Falls through into step_in_direction.
move_party_forward:
		ld	a,(iy+3)
		ld	(iy+$3D),0
		ld	(iy+$40),0
