; --- start_combat ($D9F8-$DA0C) ----------------------------
; @done

start_combat:
		ld	(ACTIVE_GUARDIAN),a
		ld	a,1
		ld	(COMBAT_ACTIVE_FLAG),a
		ld	(encounter_ctr),a
		ld	(iy+$4D),0
		call	combat_foes
		GET_GAME_VARIABLE $51
