; --- fight_or_run -------------------------------------------
; @done
; Entry to a combat encounter. Unless the party was ambushed (or has
; no hero able to act), asks the player (F)ight or (R)un. On (R)un it
; rolls the escape chance (auto-escape 1/8, then modified by whether
; the party is underground and by the time of day); success sets
; VAR_FLEE_SUCCESS and returns, otherwise it falls into party_fight.
; In:  iy = game variables base
; Out: VAR_FLEE_SUCCESS set if the party got away
fight_or_run:
		ld	(iy+VAR_FLEE_SUCCESS),0

		GET_GAME_VARIABLE	VAR_AMBUSH_FLAG			; ???

		jr	nz,party_fight

		FIND_ALIVE_HERO

		jr	c,party_fight

		PRINT_CRLF_AND_MESSAGE	0			; "Will you stalwart band (F)ight or (R)un?"

loop_run_fight:
		WAIT_KEY_DOWN

		cp	'F'
		jr	z,party_fight

		cp	'R'
		jr	nz,loop_run_fight

party_run:
		call	disbelieve_roll
		jr	c,.check_escape
		jr	nz,.check_escape

.flee_ok:
		inc	(iy+VAR_FLEE_SUCCESS)

		ret
; -------------------------------------

.check_escape:
		GET_RND_BY_PARAM	7

		jr	z,.flee_ok

		GET_GAME_VARIABLE	VAR_UNDERGROUND

		jr	nz,party_fight

		GET_GAME_VARIABLE	VAR_DAY_PART

		jr	nz,party_fight

		GET_RND_BY_PARAM	3

		jr	z,.flee_ok

party_fight:
		call	nullify_FDDD
		ld	b,1

; --- battle_hero_loop (per-hero command loop) -----------------------
; @done
; Loops over party slots b=1..6, letting each living, able hero pick a
; battle action. For each slot it fetches the hero (empty slot ends the
; round via confirm_round), then either shows the options menu
; (battle_options) or auto-assigns a default action when the hero is
; incapacitated. Continues at commit_action to record the action.
; In:  b = slot to start from, iy = game variables base
battle_hero_loop:
		ld	c,0

		CLEAR_INFO_PANEL

		FIND_HERO_BY_B

		jp	z,confirm_round

		CHECK_HERO_STATUS

		jr	nc,.skip_options
		jr	z,battle_options

		ld	a,8

		GET_B_FROM_LIST	$56

.skip_options:
		jp	commit_action
