; --- point_ix_to_record ------------------------------------
; @done
; Index a 2-byte pointer table at $D70C by A*2 and load IX with the record pointed to.
; In: a = index.  Out: ix = record.
; TODO: label the $D70C pointer table (lives in the handle_chest file).
point_ix_to_record:
		sla	a
		ld	e,a
		ld	d,0
		ld	hl,chest_trap_name_ptrs
		add	hl,de
		ld	e,(hl)
		inc	hl
		ld	d,(hl)
		ex	de,hl
		push	hl
		pop	ix
		ret
