; --- ev_teleport ($D4A0-$D4BF) -----------------------------
; @done
; Special event: read a coord pair from the record -> party position (iy+1/iy+2).

ev_teleport:
		ld	de,15
		add	hl,de
		ld	a,(hl)
		ld	(iy+1),a
		inc	hl
		ld	a,(hl)
		ld	(iy+2),a
		GET_GAME_VARIABLE $27
		jr	nz,.skip
		inc	(iy+$27)
		call	redraw_location
		dec	(iy+$27)
.skip:
		call	redraw_location
		jr	ev_set_flags.skip2
