; --- ev_smoke ($D3DF-$D3E8) ------------------------------------
; @wip
; Special event: set smoke/darkness state, print 'smoke in your eyes!'.

ev_smoke:
		ld	a,1
		call	set_state_and_redraw
		PRINT_MESSAGE2 $03
		jr	event_done
