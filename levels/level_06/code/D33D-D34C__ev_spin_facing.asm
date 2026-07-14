; --- ev_spin_facing ($D33D-$D34C) ----------------------------------
; @done
; Special event: randomise face_direction, redraw compass+view (contains event_done).

ev_spin_facing:
		GET_RND_NUMBERS
		and	3
		ld	(iy+3),a
		call	show_compass
		call	redraw_location
.skip:
		jp	process_cell_features.done
