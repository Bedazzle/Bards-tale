; --- ev_set_flags ($D330-$D344) ----------------------------------
; @done
; Special event: set the 4 party flags at $5FCE.

ev_set_flags:
		ld	hl,shield_state
		ld	b,4
.loop:
		ld	a,(hl)
		or	a
		jr	z,.skip
		ld	(hl),1
.skip:
		dec	hl
		djnz	.loop
		ld	(iy+4),1
.skip2:
		jp	ev_spin_facing.skip
