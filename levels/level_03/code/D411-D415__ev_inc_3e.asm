; --- ev_inc_3e ($D411-$D415) -----------------------------------
; @done
; Special event: increment counter (iy+$3E).

ev_inc_3e:
		inc	(iy+$3E)
		jr	event_done
