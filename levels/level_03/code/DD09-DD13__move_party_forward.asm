; --- move_party_forward ($DD09-$DD13) --------------------------
; @done
; Reset combat flags then step the party one cell in the face_direction direction.
; In:  (iy+3) = face_direction; steps the party one cell forward

move_party_forward:
		ld	a,(iy+3)		; face_direction
		ld	(iy+$3D),0		; clear combat/encounter flags before the step
		ld	(iy+$40),0
		; falls through into step_in_facing
