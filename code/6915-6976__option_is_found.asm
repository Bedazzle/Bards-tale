; --- option_is_found ----------------------------------------
; @done
; Acts on the battle option the hero picked in battle_options. Rejects
; options that are not available this round (availability mask in c),
; then dispatches by option index: option 4 = cast/use a spell (prompts
; for the spell, checks the hero has enough spell points, then selects a
; target via select_spell_target); option 3 = a second cast/use path; anything else
; falls through to handle_battle_actions (attack / party attack / hide / bard). The
; chosen action is recorded via commit_action; a cancel returns to the
; per-hero loop at battle_hero_loop.
; In:  e = matched option index-1, c = availability mask, ix = hero,
;      iy = game variables base
; Note: option semantics partially inferred from the dispatch chain.
option_is_found:
		GET_E_FROM_TABLE	$39

		jr	z,.option_ok

		and	c
		jr	z,loop_option

.option_ok:
		inc	e
		ld	a,e

		GET_B_FROM_LIST	$56

		cp	4
		jr	nz,battle_cant_use.check_opt3	; forward ref past the stray global

		push	bc
		call	use_which_item
		pop	bc
		jr	z,option_cancel
		jr	c,battle_cant_use

		push	af
		ld	a,l

		GET_B_FROM_LIST	$3A

		pop	af
		and	$7F

		cp	$10
		jr	c,battle_cant_use

		GET_A_FROM_TABLE	$6A

		GET_B_FROM_LIST	$51

		ld	(GAME_VARIABLES + VAR_CURRENT_SPELL),a
		call	select_spell_target
		jr	nc,option_cancel

		GET_B_FROM_LIST	$3B

		jp	commit_action

; -------------------------------------

; Message "You can't use that", then cancels back to the hero loop.
; (The .check_opt3 / .cancel dot-locals below are scoped to this label.)
battle_cant_use:
		PRINT_MESSAGE	$11			; "You can't use that."

		jr	.cancel
; -------------------------------------

.check_opt3:
		cp	3
		jr	nz,handle_battle_actions

		ld	a,8
		ld	c,8
		call	cast_spell_by_e
		jr	nc,option_cancel.cast_at_target	; ref past the stray global option_cancel

.cancel:
		CHANGE_SPEED_TO_8

; Re-enter the per-hero command loop (retry this hero's choice).
option_cancel:
		jp	battle_hero_loop
; -------------------------------------

.cast_at_target:
		ld	a,(GAME_VARIABLES + VAR_CURRENT_SPELL)

		GET_B_FROM_LIST	$3C

		call	select_spell_target
		jr	nc,option_cancel

; Record the chosen spell action (index $51) and commit via commit_action.
option_cast_spell:
		GET_B_FROM_LIST	$51

		jp	commit_action
