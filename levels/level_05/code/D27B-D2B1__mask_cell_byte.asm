; --- mask_cell_byte ($D27B-$D2B1) ----------------------------------
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
.skip:
		ld	b,1
.skip2:
		push	bc
		ld	hl,$D376
.loop:
		inc	hl
		inc	hl
		inc	hl
		inc	hl
		djnz	.loop
		ld	b,(hl)
		inc	hl
		ld	c,(hl)
		inc	hl
		ld	e,(hl)
		inc	hl
		ld	d,(hl)
		ld	($D2B0),de
		ld	hl,$FA40
		ld	e,c
		ld	d,0
		add	hl,de
.skip3:
		ld	a,(hl)
		inc	hl
		cp	(iy+1)
		jr	nz,dispatch_scan_loop
		ld	a,(hl)
		cp	(iy+2)
		jr	nz,dispatch_scan_loop
		pop	bc
.loop2:
		jp	.loop2
