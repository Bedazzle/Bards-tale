; --- point_ix_to_record ($D98D-$D99D) ----------------------------------
; @done
; Index the WORD pointer table at $D83E by A*2 -> ix.
; In:  a = record index
; Out: ix = record pointer (from the $D83E table)

point_ix_to_record:
		sla	a
		ld	e,a
		ld	d,0
		ld	hl,$D7AC
		add	hl,de
		ld	e,(hl)
		inc	hl
		ld	d,(hl)
		ex	de,hl
		push	hl
		pop	ix
		ret
