; --- ev_dispatch_smc ($D429-$D440) -----------------------------
; @wip
; Special event: read a handler pointer from the record and SMC-call it (slot $D434).

ev_dispatch_smc:
		ld	de,15
		add	hl,de
		ld	e,(hl)
		inc	hl
		ld	d,(hl)
		ld	($d435),de
.d434:
		call	.d434
		GET_GAME_VARIABLE $3d
		jr	nz,event_done
		call	redraw_location
		jr	event_done
