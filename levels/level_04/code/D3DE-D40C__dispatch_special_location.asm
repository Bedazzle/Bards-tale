; --- dispatch_special_location ($D3DE-$D40C) ---------------
; @done
; Scan the special-location list ($FA40) for the party cell and SMC-dispatch its event handler (jp slot $D3C0).
; In:  party cell (iy+1/iy+2); fires that cell's special event via the SMC jp

dispatch_special_location:
		ld	b,1
.skip:
		push	bc
		ld	hl,$D4D1
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
		ld	($D40B),de
		ld	hl,$FA40
		ld	e,c
		ld	d,0
		add	hl,de
.skip2:
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
