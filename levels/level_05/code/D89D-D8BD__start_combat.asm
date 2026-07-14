; --- start_combat ($D89D-$D8BD) ----------------------------------
; @done

start_combat:
		ld	(ACTIVE_GUARDIAN),a
		ld	a,1
		ld	(COMBAT_ACTIVE_FLAG),a
		ld	(encounter_ctr),a
		ld	(iy+$4D),0
		call	combat_foes
		GET_GAME_VARIABLE $51
		ret

		db $F5,$CD,$34,$67,$F1,$CD,$D1,$C2	; ..4g....
		db $C3,$AA,$62	; ..b
