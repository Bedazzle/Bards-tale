INIT_GAME:
		ld	iy, GAME_VARIABLES
		ld	hl, GAME_VARIABLES + VAR_76
		ld	b, 6Fh
		call	nullify_buffer
		xor	a
		ld	(iy+VAR_58), 5

set_vars_and_IM:
		di
		ld	sp, STACK
		ld	iy, GAME_VARIABLES
		ld	(iy+VAR_48), 18h
		ld	(iy+VAR_PAUSE), 0			; pause off
		ld	(iy+VAR_INFO_COL_POS), 15h	; 21

		di
		ld	a, 2Bh
		ld	i, a
		im	2
		ei

jmp_main_loop:
		jp	game_cycle
