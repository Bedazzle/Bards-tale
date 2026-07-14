; --- ev_inc_2f ($D37A-$D37E) ----------------------------------
; @done
; Special event: increment counter (iy+$2F).

ev_inc_2f:
		inc	(iy+$2F)
		jr	ev_spin_facing.skip
