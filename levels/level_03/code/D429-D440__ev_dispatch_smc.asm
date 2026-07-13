; --- ev_dispatch_smc ($D429-$D440) -----------------------------
; @done
; Special event: read a handler pointer from the record and SMC-call it (slot $D434).

ev_dispatch_smc:
		ld	de,15			; -> the record's data payload
		add	hl,de
		ld	e,(hl)			; record's special-handler pointer
		inc	hl
		ld	d,(hl)
		ld	(.handler),de		; patch the call target below
.dispatch:
		call	.dispatch		; SMC: target set above
.handler EQU $-2
		GET_GAME_VARIABLE $3D
		jr	nz,event_done
		call	redraw_location
		jr	event_done
