; --- ev_teleport ($D456-$D475) ---------------------------------
; @done
; Special event: read a coord pair from the record -> party position (iy+1/iy+2).

ev_teleport:
		ld	de,15			; -> the record's data payload
		add	hl,de
		ld	a,(hl)
		ld	(iy+1),a		; new N/S coord
		inc	hl
		ld	a,(hl)
		ld	(iy+2),a		; new W/E coord
		GET_GAME_VARIABLE $27
		jr	nz,.redraw
		inc	(iy+$27)		; suppress the encounter check across the jump
		call	redraw_location
		dec	(iy+$27)
.redraw:
		call	redraw_location
		jr	ev_set_flags.done
