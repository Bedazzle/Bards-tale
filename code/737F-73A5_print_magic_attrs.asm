print_magic_attrs:
		PUSH_REGS

		PRINT_MESSAGE	1Dh			; "Sorc:   Conj:"
									; "Magi:   Wizd:"

		dec	(iy+VAR_CURSOR_ROW)
		ld	hl, MAGIC_COLUMNS
		push	hl
		call	loop_magic_attr
		call	loop_magic_attr

		PRINT_NEWLINE

		pop	hl
		call	loop_magic_attr

loop_magic_attr:
		ld	a, (hl)
		ld	(GAME_VARIABLES + VAR_CURSOR_COL), a
		ld	e, (ix+CHAR_SORC_LEVEL)		; Sorc, Conj, Magi, Wizd spell level

		PRINT_NUM_FROM_E

		inc	ix
		inc	hl

		ret

MAGIC_COLUMNS:
		db 1Ah
		db 23h
