; --- ev_start_encounter ($D3E9-$D406) --------------------------
; @wip
; Special event: load a fixed encounter record -> ACTIVE_GUARDIAN + COMBAT_ACTIVE_FLAG.

ev_start_encounter:
		ld	de,15
		add	hl,de
		ld	a,(hl)
		ld	(ACTIVE_GUARDIAN),a
		inc	hl
		ld	a,(hl)
		ld	(COMBAT_ACTIVE_FLAG),a
		ld	(iy+$4d),0
		inc	(iy+$5b)
		inc	(iy+$3f)
		ld	a,$fb
		call	mask_cell_byte
		jr	event_done
