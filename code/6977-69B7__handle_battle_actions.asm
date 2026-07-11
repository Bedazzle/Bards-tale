; --- handle_battle_actions (dispatch attack / hide options) --------------
; @done
; Continuation of the battle-option dispatch for options that were not
; the spell paths handled in option_is_found. Option 1 = melee Attack
; (mode 4) and option 7 = party Attack (mode 1) both print the enemy
; group and select a target; option 5 = Hide in shadows, which succeeds
; only for an equipped Rogue whose stealth roll beats CHAR_ROGUE_HIDE.
; Unhandled values fall through to battle_play_tune / the default.
; In:  a = option index, b = party slot, ix = hero, iy = game vars
; Note: option-to-action mapping partially inferred.
handle_battle_actions:
		cp	1
		jr	nz,check_attack

		ld	a,(byte_FB99)
		or	a
		jr	z,.attack_melee

		call	print_enemy_group

		PRINT_MESSAGE	9			; "Attack"

.attack_melee:
		ld	a,4
		jr	check_attack.select_target

; Option 7: party attack (attack mode 1).
check_attack:
		cp	7
		jr	nz,check_playtune

		call	print_enemy_group

		PRINT_MESSAGE	9			; "Attack"

		ld	a,1

.select_target:
		SELECT_TARGET

		jr	c,option_cancel
		jr	option_cast_spell

; Option 5: (H)ide in shadows - Rogue stealth attempt.
check_playtune:
		cp	5
		jr	nz,battle_play_tune

		xor	a

		GET_B_FROM_LIST	$40

		CHECK_EQUIPPED	6

		jr	nc,.hide_failed

		GET_RND_NUMBERS

		cp	(ix+CHAR_ROGUE_HIDE)
		jr	nc,commit_action

.hide_failed:
		ld	a,1

		GET_B_FROM_LIST	$40

		jr	commit_action
