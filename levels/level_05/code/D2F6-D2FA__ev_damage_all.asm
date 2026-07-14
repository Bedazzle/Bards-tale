; --- ev_damage_all ($D2F6-$D2FA) ----------------------------------
; @done
; Special event: damage all enemy groups.

ev_damage_all:
		call	damage_all_groups
		jr	ev_spin_facing.skip
