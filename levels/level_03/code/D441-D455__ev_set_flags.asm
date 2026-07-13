; --- ev_set_flags ($D441-$D455) --------------------------------
; @done
; Special event: set the 4 party flags at $5FCE.

ev_set_flags:
		ld	hl,shield_state
		ld	b,4			; 4 party flags
.loop:
		ld	a,(hl)
		or	a
		jr	z,.next			; leave a zero slot alone
		ld	(hl),1
.next:
		dec	hl
		djnz	.loop
		ld	(iy+4),1
.done:
		jp	event_done
