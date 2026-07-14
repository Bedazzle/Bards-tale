; --- set_state_and_redraw ($D272-$D27A) ----------------------------------
; @done
; Store A to the view-state var ($5FD2), redraw the location, clear the info panel.
; In:  a = view-state value (stored to $5FD2), then redraw + clear panel

set_state_and_redraw:
		ld	(light_dist),a
		call	redraw_location
		jp	clear_info_panl
