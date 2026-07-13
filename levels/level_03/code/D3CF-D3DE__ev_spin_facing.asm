; --- ev_spin_facing ($D3CF-$D3DE) ------------------------------
; @done
; Special event: randomise face_direction, redraw compass+view (contains event_done).

ev_spin_facing:
		GET_RND_NUMBERS
		and	3			; random face_direction 0-3 (disorient)
		ld	(iy+3),a
		call	show_compass
		call	redraw_location
event_done:
		jp	process_cell_features.next
