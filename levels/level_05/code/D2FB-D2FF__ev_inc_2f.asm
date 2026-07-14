; --- ev_inc_2f ($D2FB-$D2FF) ----------------------------------
; @done
; Special event: increment counter (iy+$2F).

ev_inc_2f:
		inc	(iy+$2F)
		jr	ev_spin_facing.skip
