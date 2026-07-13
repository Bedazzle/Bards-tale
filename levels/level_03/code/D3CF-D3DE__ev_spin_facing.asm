; --- ev_spin_facing ($D3CF-$D3DE) ------------------------------
; @wip
; Special event: randomise facing, redraw compass+view (contains event_done).

ev_spin_facing:
		GET_RND_NUMBERS
		and	3
		ld	(iy+3),a
		call	show_compass
		call	redraw_location
event_done:
		jp	process_cell_features.d375
