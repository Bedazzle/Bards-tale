; --- ev_dispatch_smc ($D397-$D3A1) ----------------------------------
; @done
; Special event: read a handler pointer from the record and SMC-call it (slot $D434).

ev_dispatch_smc:
		ld	de,15
		add	hl,de
		ld	e,(hl)
		inc	hl
		ld	d,(hl)
		ld	($D3A3),de
