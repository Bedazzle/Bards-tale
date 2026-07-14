; --- mask_cell_byte ($D2FA-$D33C) ----------------------------------
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
.loop:
		push	bc
		ld	hl,$D3F5
.loop2:
		inc	hl
		inc	hl
		inc	hl
		inc	hl
		djnz	.loop2
		ld	b,(hl)
		inc	hl
		ld	c,(hl)
		inc	hl
		ld	e,(hl)
		inc	hl
		ld	d,(hl)
		ld	($D32F),de
		ld	hl,$FA40
		ld	e,c
		ld	d,0
		add	hl,de
.loop3:
		ld	a,(hl)
		inc	hl
		cp	(iy+1)
		jr	nz,.skip2
		ld	a,(hl)
		cp	(iy+2)
		jr	nz,.skip2
		pop	bc
.loop4:
		jp	.loop4
.skip2:
		inc	hl
		djnz	.loop3
		pop	bc
		inc	b
		ld	a,b
		cp	11
		jr	c,.loop
		jr	process_cell_features.done
