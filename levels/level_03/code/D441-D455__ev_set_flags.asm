; --- ev_set_flags ($D441-$D455) --------------------------------
; @wip
; Special event: set the 4 party flags at $5FCE.

ev_set_flags:
		ld	hl,var_5FCE
		ld	b,4
.d446:
		ld	a,(hl)
		or	a
		jr	z,.d44c
		ld	(hl),1
.d44c:
		dec	hl
		djnz	.d446
		ld	(iy+4),1
.d453:
		jp	event_done
