; --- ev_start_encounter ($D3E9-$D406) --------------------------
; @done
; Special event: load a fixed encounter record -> ACTIVE_GUARDIAN + COMBAT_ACTIVE_FLAG.

ev_start_encounter:
		ld	de,15			; -> the record's data payload
		add	hl,de
		ld	a,(hl)
		ld	(ACTIVE_GUARDIAN),a	; which fixed encounter
		inc	hl
		ld	a,(hl)
		ld	(COMBAT_ACTIVE_FLAG),a
		ld	(iy+$4D),0
		inc	(iy+$5B)
		inc	(iy+$3F)
		ld	a,$FB			; clear the trigger feature bit
		call	mask_cell_byte
		jr	event_done
