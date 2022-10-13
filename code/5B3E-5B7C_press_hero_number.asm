press_hero_number:
		cp	(iy+VAR_PRESSED_KEY)
		jr	z, loop_city_walk

		ld	(GAME_VARIABLES + VAR_PRESSED_KEY), a

		cp	'1'
		jr	c, no_hero

		cp	'7'
		jr	nc, no_hero

		sub	'0'
		call	print_hero_stats

		jr	wait_city_walk

no_hero:
		call	sub_7406
		jr	c, check_abort_move

		CLEAR_INFO_PANEL

		jr	wait_city_walk

check_abort_move:
		ld	a, (GAME_VARIABLES + VAR_PRESSED_KEY)

		cp	CODE_ABORT
		jr	nz, wait_movement

		CLEAR_INFO_PANEL

		call	pause_speed

		CLEAR_INFO_PANEL

		jr	wait_city_walk

wait_movement:
		call	jmp_to_movement

		jr	loop_city_walk

wait_city_walk:
		ld	a, (GAME_VARIABLES + VAR_KEEP_PRESSED)
		ld	(GAME_VARIABLES + VAR_PRESSED_KEY), a

		RST_10_4B

		jr	loop_city_walk
