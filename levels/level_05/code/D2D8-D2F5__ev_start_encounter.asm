; --- ev_start_encounter ($D2D8-$D2F5) ----------------------------------
; @done
; Special event: load a fixed encounter record -> ACTIVE_GUARDIAN + COMBAT_ACTIVE_FLAG.

ev_start_encounter:
		ld	de,15
		add	hl,de
		ld	a,(hl)
		ld	(ACTIVE_GUARDIAN),a
		inc	hl
		ld	a,(hl)
		ld	(COMBAT_ACTIVE_FLAG),a
		ld	(iy+$4D),0
		inc	(iy+$5B)
		inc	(iy+$3F)
		ld	a,$FB
		call	mask_cell_byte
		jr	ev_spin_facing.skip
