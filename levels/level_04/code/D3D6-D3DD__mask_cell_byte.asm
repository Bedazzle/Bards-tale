; --- mask_cell_byte ($D3D6-$D3DD) --------------------------
; @done
; AND the party's maze feature-plane cell byte with A, storing it back.
; In:  a = AND mask (applied to the cell feature byte)

mask_cell_byte:
		push	af
		call	get_cell_feature
		pop	af
		and	(hl)
		ld	(hl),a
		ret
