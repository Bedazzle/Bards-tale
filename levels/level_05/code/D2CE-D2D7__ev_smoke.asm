; --- ev_smoke ($D2CE-$D2D7) ----------------------------------
; @done
; Special event: set smoke/darkness state, print 'smoke in your eyes!'.

ev_smoke:
		ld	a,1
		call	set_state_and_redraw
		PRINT_MESSAGE2 $03
		jr	ev_spin_facing.skip
