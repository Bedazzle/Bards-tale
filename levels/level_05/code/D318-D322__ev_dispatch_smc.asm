; --- ev_dispatch_smc ($D318-$D322) ----------------------------------
; @done
; Special event: read a handler pointer from the record and SMC-call it (slot $D434).

ev_dispatch_smc:
		ld	de,15
		add	hl,de
		ld	e,(hl)
		inc	hl
		ld	d,(hl)
		ld	($D324),de
