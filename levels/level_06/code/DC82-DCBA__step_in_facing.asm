; --- step_in_facing ($DC82-$DCBA) ----------------------------------
; @done
; Advance a coord one cell in the face_direction direction (0-3), wrapping.
; In:  a = face_direction (1-3)
; Out: the party coord advanced one cell, wrapped

step_in_facing:
		dec	a
		jr	z,.skip3
		dec	a
		jr	z,.skip
		dec	a
		jr	z,.skip2
		inc	(iy+1)
.loop:
		ld	a,(iy+1)
		ld	(iy+$38),a
		call	wrap_view_ns
		ld	a,(iy+$38)
		ld	(iy+1),a
		ret
.skip:
		dec	(iy+1)
		jr	.loop
.skip2:
		dec	(iy+2)
		jr	.done
.skip3:
		inc	(iy+2)
.done:
		ld	a,(iy+2)
		ld	(iy+$39),a
		call	wrap_view_we
		ld	a,(iy+$39)
		ld	(iy+2),a
		ret
