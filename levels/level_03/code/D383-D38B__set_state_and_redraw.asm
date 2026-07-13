; --- set_state_and_redraw ($D383-$D38B) ------------------------
; @wip
; Store A to the view-state var ($5FD2), redraw the location, clear the info panel.

set_state_and_redraw:
		ld	(var_5FD2),a
		call	redraw_location
		jp	clear_info_panl
