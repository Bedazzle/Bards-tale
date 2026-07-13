; --- point_ix_to_record ($DA1F-$DA2F) --------------------------
; @wip
; Index the WORD pointer table at $D83E by A*2 -> ix.

point_ix_to_record:
		sla	a
		ld	e,a
		ld	d,0
		ld	hl,$d83e
		add	hl,de
		ld	e,(hl)
		inc	hl
		ld	d,(hl)
		ex	de,hl
		push	hl
		pop	ix
		ret
