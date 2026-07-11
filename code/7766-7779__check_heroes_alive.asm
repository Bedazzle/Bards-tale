; --- check_heroes_alive --------------------------------------------
; @done
; CHECK_ALL_HEROES handler: runs check_hero_alive across the whole
; party to determine whether any active/living hero remains.
check_heroes_alive:								; CHECK_ALL_HEROES
		EXEC_FOR_HEROES	check_hero_alive

		ret

; --- check_hero_alive ---------------------------------------
; @done
; EXEC_FOR_HEROES callback reporting whether the current hero counts
; as an active combatant: returns carry set (and aborts the party
; scan) for a hero that passes the status check and has no negating
; flag; otherwise clears carry and drops this hero's iteration.
; In:  ix = hero record
; Out: carry set = an active hero was found
; Note: the `pop af` discards the dispatcher frame to break out of
;       EXEC_FOR_HEROES early; exact stack semantics partially inferred.
check_hero_alive:
		CHECK_HERO_STATUS

		ccf
		jr	nc,.not_this_hero

		GET_ATTR_BY_PARAM_SAVE_HL	CHAR_NEG_FLAG

		jr	nz,.not_this_hero
		scf

		ret

.not_this_hero:
		pop	af
		and	a

		ret
