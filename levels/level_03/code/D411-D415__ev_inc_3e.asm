; --- ev_inc_3e ($D411-$D415) -----------------------------------
; @wip
; Special event: increment counter (iy+$3e).

ev_inc_3e:
		inc	(iy+$3e)
		jr	event_done
