; --- battle_play_tune ---------------------------------------
; @done
; Option 6: (P)lay tune - the Bard's battle-song action. Prompts for a
; tune number 1-6 (ENTER_1_TO_6); an aborted entry cancels back to the
; per-hero loop. On a valid choice it records the chosen song action
; (list $51, tune index 0-5) and commits via commit_action.
; In:  a = option index, ix = hero, iy = game variables base
battle_play_tune:
		cp	6
		jr	nz,commit_action

		CLEAR_INFO_PANEL

		PRINT_CRLF_AND_MESSAGE	1	; "Play tune"

		PRINT_MESSAGE	$44			; "(1-6)"

enter_tune_number:
		ENTER_1_TO_6

		jr	nc,play_chosen_tune

		cp	$EA
		jr	z,option_cancel

		jr	enter_tune_number

play_chosen_tune:
		dec	a

		GET_B_FROM_LIST	$51

; --- commit_action (record action, advance to next hero) ---------
; @done
; Shared tail reached by every battle-option handler once the hero has
; committed an action. If the hero is under a negation effect
; (CHAR_NEG_FLAG) the action is replaced by the default (list $56,
; value 8). Then advances b to the next party slot and loops back to
; battle_hero_loop; after slot 6 it falls into confirm_round to confirm the round.
; In:  b = current slot, ix = hero, iy = game variables base
commit_action:
		GET_ATTR_BY_PARAM_SAVE_HL	CHAR_NEG_FLAG

		jr	z,.next_hero

		ld	a,8

		GET_B_FROM_LIST	$56

.next_hero:
		inc	b
		ld	a,b

		cp	7
		jp	c,battle_hero_loop

; --- confirm_round (confirm the round's commands) ----------------
; @done
; End of command entry for the round: asks "Use these commands?" and,
; on No, restarts command entry at party_fight. On Yes it finalises the
; per-hero action list at HERO_ACTION_CODE+$6 (turning any still-unset entry, code
; 7, into the default 1), clears the info panel and returns so combat
; resolution can run.
; In:  iy = game variables base
confirm_round:
		CLEAR_INFO_PANEL

		PRINT_MESSAGE	$0A			; "Use these commands?"

		PRINT_YES_NO_WAIT

		jp	nc,party_fight

		ld	b,7
		ld	hl,HERO_ACTION_CODE+$6

.commit_loop:
		ld	a,(hl)

		cp	7
		jr	nz,.next_entry

		ld	(hl),1

.next_entry:
		dec	hl
		djnz	.commit_loop

		CLEAR_INFO_PANEL

		ld	(iy+VAR_CURSOR_ROW),$0E

		ret
