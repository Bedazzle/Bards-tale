; --- step_in_facing ($DD14-$DD4C) ------------------------------
; @done
; Advance a coord one cell in the face_direction direction (0-3), wrapping.
; In:  a = face_direction (1-3)
; Out: the party coord advanced one cell, wrapped

step_in_facing:
		dec	a			; face_direction 1 -> +W/E
		jr	z,.inc_we
		dec	a			; face_direction 2 -> -N/S
		jr	z,.dec_ns
		dec	a			; face_direction 3 -> -W/E
		jr	z,.dec_we
		inc	(iy+1)			; face_direction 0 -> +N/S
.wrap_ns:
		ld	a,(iy+1)
		ld	(iy+$38),a
		call	wrap_view_ns
		ld	a,(iy+$38)
		ld	(iy+1),a
		ret

.dec_ns:
		dec	(iy+1)
		jr	.wrap_ns

.dec_we:
		dec	(iy+2)
		jr	.wrap_we

.inc_we:
		inc	(iy+2)
.wrap_we:
		ld	a,(iy+2)
		ld	(iy+$39),a
		call	wrap_view_we
		ld	a,(iy+$39)
		ld	(iy+2),a
		ret
