; --- mask_cell_byte ----------------------------------------
; @done
; AND the party's maze wall-plane cell byte with A, storing it back.
; In:  a = mask.  Uses get_cell_feature (returns hl = cell addr).
mask_cell_byte:
		push	af
		call	get_cell_feature
		pop	af
		and	(hl)
		ld	(hl),a
		ret
