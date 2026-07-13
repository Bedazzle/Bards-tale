; --- ev_damage_all ($D407-$D40B) -------------------------------
; @done
; Special event: damage all enemy groups.

ev_damage_all:
		call	damage_all_groups
		jr	event_done
