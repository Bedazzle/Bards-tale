; --- spell_ac_modifier --------------------------------------
; @done
; Armour-class buff/debuff spell handler. Reads the AC delta for
; this spell (table $20). If the caster flag (bit 7 of
; VAR_ACTIVE_HERO) is set the delta is added to the enemy group's
; AC modifier (VAR_AC_MOD_ENEMY); otherwise it is applied to the
; targeted party member's AC fields (tables $2D and $55, indexed by
; VAR_TARGET_ID). Ends by printing "...".
; In:  iy = game variables
spell_ac_modifier:
		GET_B_FROM_TABLE	$20

		bit	7,(iy+VAR_ACTIVE_HERO)
		jr	z,.modify_target

		ld	hl,GAME_VARIABLES + VAR_AC_MOD_ENEMY
		add	a,(hl)
		ld	(hl),a

		jr	.done

.modify_target:
		ld	c,a
		ld	a,(GAME_VARIABLES + VAR_TARGET_ID)
		and	$7F
		ld	b,a

		GET_B_FROM_TABLE	$2D

		A_PLUS_C_TO_HL

		GET_B_FROM_TABLE	$55

		A_PLUS_C_TO_HL

.done:
		jr	jp_print_ellipsis
