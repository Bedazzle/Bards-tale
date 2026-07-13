; --- ev_inc_2f ($D40C-$D410) -----------------------------------
; @done
; Special event: increment counter (iy+$2F).

ev_inc_2f:
		inc	(iy+$2F)
		jr	event_done
