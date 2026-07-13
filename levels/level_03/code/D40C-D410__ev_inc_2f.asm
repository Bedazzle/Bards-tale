; --- ev_inc_2f ($D40C-$D410) -----------------------------------
; @wip
; Special event: increment counter (iy+$2f).

ev_inc_2f:
		inc	(iy+$2f)
		jr	event_done
