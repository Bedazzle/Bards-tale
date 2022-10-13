print_spaces_eol:
		push	de
		ld	e, a

loop_print_spaces:
		ld	a, (GAME_VARIABLES + VAR_CURSOR_COL)

		cp	e
		jr	nc, exit_loop_spaces

		PRINT_SPACE

		jr	loop_print_spaces

exit_loop_spaces:
		pop	de

		ret
