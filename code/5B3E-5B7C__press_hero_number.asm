; --- press_hero_number ------------------------------------
; @done
; Key handler reached from game_cycle while a key is held. Ignores
; an unchanged key; a digit 1-6 opens that party member's stat
; sheet (print_hero_stats); anything else is offered to the
; movement/command handler (run_default_action) or treated as CODE_ABORT
; (which pauses). Always rejoins the city walk loop.
; In:  a = key code, iy = game variables base
press_hero_number:
		cp	(iy+VAR_PRESSED_KEY)
		jr	z,loop_city_walk

		ld	(GAME_VARIABLES + VAR_PRESSED_KEY),a

		cp	'1'
		jr	c,no_hero

		cp	'7'
		jr	nc,no_hero

		sub	'0'
		call	print_hero_stats

		jr	wait_city_walk

no_hero:
		call	run_default_action
		jr	c,check_abort_move

		CLEAR_INFO_PANEL

		jr	wait_city_walk

check_abort_move:
		ld	a,(GAME_VARIABLES + VAR_PRESSED_KEY)

		cp	CODE_ABORT
		jr	nz,wait_movement

		CLEAR_INFO_PANEL

		call	pause_speed

		CLEAR_INFO_PANEL

		jr	wait_city_walk

wait_movement:
		call	jmp_to_movement

		jr	loop_city_walk

wait_city_walk:
		ld	a,(GAME_VARIABLES + VAR_KEEP_PRESSED)
		ld	(GAME_VARIABLES + VAR_PRESSED_KEY),a

		DISPATCH_MOVEMENT

		jr	loop_city_walk
