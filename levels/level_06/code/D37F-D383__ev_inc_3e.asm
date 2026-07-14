; --- ev_inc_3e ($D37F-$D383) ----------------------------------
; @done
; Special event: increment counter (iy+$3E).

ev_inc_3e:
		inc	(iy+$3E)
		jr	ev_spin_facing.skip
