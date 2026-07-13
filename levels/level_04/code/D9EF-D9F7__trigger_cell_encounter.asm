; --- trigger_cell_encounter ($D9EF-$D9F7) ----------------------------------
; @done
; Start combat at the current cell; if none started, clear the cell feature bit
; (mask $FB) via mask_cell_byte.

trigger_cell_encounter:
		call	start_combat
		ret	nz
		ld	a,$FB
		jp	mask_cell_byte
