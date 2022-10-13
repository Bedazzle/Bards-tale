print_N_enemies:
		PUSH_REGS

		ld	hl, addr_FB98
		ld	b, 0

loop_enemy_block:
		ld	a, (hl)
		or	a
		ret	z

		ld	a, '['

		PRINT_WITH_CODES

		ld	a, b
		add	a, 'a'

		PRINT_WITH_CODES

		ld	a, ']'

		PRINT_WITH_CODES

		PRINT_SPACE

		ld	a, (hl)
		ld	e, a
		dec	a
		ld	(GAME_VARIABLES + VAR_4F), a

		PRINT_NUM_FROM_E

		GET_B_FROM_TABLE	41h

		PRINT_WORD

		PRINT_NEWLINE

		inc	hl
		inc	b
		ld	a, b

		cp	4
		jr	nz, loop_enemy_block

		ret
