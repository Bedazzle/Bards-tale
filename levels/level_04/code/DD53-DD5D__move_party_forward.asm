; --- move_party_forward ($DD53-$DD5D) ----------------------
; @done
; Reset combat flags then step the party one cell in the face_direction direction.
; In:  (iy+3) = face_direction; steps the party one cell forward

move_party_forward:
		ld	a,(iy+3)
		ld	(iy+$3D),0
		ld	(iy+$40),0
