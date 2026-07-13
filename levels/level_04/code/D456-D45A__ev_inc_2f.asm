; --- ev_inc_2f ($D456-$D45A) -------------------------------
; @done
; Special event: increment counter (iy+$2F).

ev_inc_2f:
		inc	(iy+$2F)
		jr	ev_spin_facing.skip
