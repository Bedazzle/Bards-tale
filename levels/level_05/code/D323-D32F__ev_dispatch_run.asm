; --- ev_dispatch_run ($D323-$D32F) ----------------------------------
; @done
; ev_dispatch_smc tail: run the SMC-patched handler, then redraw the location
; if the $3D flag is set.

ev_dispatch_run:
		call	ev_dispatch_run
		GET_GAME_VARIABLE $3D
		jr	nz,ev_spin_facing.skip
		call	redraw_location
		jr	ev_spin_facing.skip
