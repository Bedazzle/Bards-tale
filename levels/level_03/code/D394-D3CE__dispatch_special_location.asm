; --- dispatch_special_location ($D394-$D3CE) -------------------
; @wip
; Scan the special-location list ($FA40) for the party cell and SMC-dispatch its event handler (jp slot $D3C0).

dispatch_special_location:
		ld	b,1
.d396:
		push	bc
		ld	hl,$d487
.d39a:
		inc	hl
		inc	hl
		inc	hl
		inc	hl
		djnz	.d39a
		ld	b,(hl)
		inc	hl
		ld	c,(hl)
		inc	hl
		ld	e,(hl)
		inc	hl
		ld	d,(hl)
		ld	($d3c1),de
		ld	hl,$fa40
		ld	e,c
		ld	d,0
		add	hl,de
.d3b2:
		ld	a,(hl)
		inc	hl
		cp	(iy+1)
		jr	nz,.d3c3
		ld	a,(hl)
		cp	(iy+2)
		jr	nz,.d3c3
		pop	bc
.d3c0:
		jp	.d3c0
.d3c3:
		inc	hl
		djnz	.d3b2
		pop	bc
		inc	b
		ld	a,b
		cp	11
		jr	c,.d396
		jr	process_cell_features.d375
