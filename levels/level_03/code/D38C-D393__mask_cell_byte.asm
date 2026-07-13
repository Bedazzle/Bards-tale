; --- mask_cell_byte ($D38C-$D393) ------------------------------
; @wip
; AND the party's maze feature-plane cell byte with A, storing it back.

mask_cell_byte:
		push	af
		call	get_cell_feature
		pop	af
		and	(hl)
		ld	(hl),a
		ret
