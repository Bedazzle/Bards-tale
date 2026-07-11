; --- step_in_direction -------------------------------------
; @done
; Step the party one maze cell in direction A (0=+NS, 1=+WE, 2=-NS, 3=-WE), wrapping
; the coordinate into 0..21 via wrap_view_ns / wrap_view_we. Updates the party
; position (iy+1 = NS, iy+2 = WE). Entered here or by falling through
; move_party_forward.
step_in_direction:
		dec	a
		jr	z,.we_plus
		dec	a
		jr	z,.ns_minus
		dec	a
		jr	z,.we_minus
		inc	(iy+1)			; A=0: +NS
.apply_ns:
		ld	a,(iy+1)
		ld	(iy+$38),a
		call	wrap_view_ns
		ld	a,(iy+$38)
		ld	(iy+1),a
		ret

.ns_minus:
		dec	(iy+1)
		jr	.apply_ns

.we_minus:
		dec	(iy+2)
		jr	.apply_we

.we_plus:
		inc	(iy+2)
.apply_we:
		ld	a,(iy+2)
		ld	(iy+$39),a
		call	wrap_view_we
		ld	a,(iy+$39)
		ld	(iy+2),a
		ret
