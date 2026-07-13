; --- point_ix_to_record ($DA1F-$DA2F) --------------------------
; @done
; Index the WORD pointer table at $D83E by A*2 -> ix.
; In:  a = record index
; Out: ix = record pointer (from the $D83E table)

point_ix_to_record:
		sla	a			; index * 2 (word entries)
		ld	e,a
		ld	d,0
		ld	hl,wandering_creature_data+$38	; the record-pointer table
		add	hl,de
		ld	e,(hl)
		inc	hl
		ld	d,(hl)
		ex	de,hl
		push	hl
		pop	ix
		ret
