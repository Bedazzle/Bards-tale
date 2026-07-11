; --- spell_attack_bonus -------------------------------------
; @done
; Attack-power buff spell handler. Reads the to-hit bonus for this
; spell (table $5C) into c, then adds it to the attack field of
; either the targeted party member (table $2C, indexed by
; VAR_TARGET_ID) or the enemy group (table $30), chosen by the
; caster flag in VAR_ACTIVE_HERO. Ends by printing "...".
; In:  iy = game variables
spell_attack_bonus:
		GET_B_FROM_TABLE	$5C

		ld	c,a

		GET_GAME_VARIABLE	VAR_ACTIVE_HERO

		ld	a,(GAME_VARIABLES + VAR_TARGET_ID)
		jr	nc,.enemy_target

		and	$7F

		GET_A_FROM_TABLE	$2C

		jr	add_attack_bonus

.enemy_target:
		GET_A_FROM_TABLE	$30

add_attack_bonus:
		A_PLUS_C_TO_HL

jp_print_ellipsis:
		jp	print_ellipsis
