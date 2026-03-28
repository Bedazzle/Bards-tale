show_damage:
		PUSH_REGS

		push	hl
		pop	de
		xor	a

		cp	d
		ld	a, e
		jr	z, loc_70C6

		inc	a

loc_70C6:
		dec	a
		ld	(GAME_VARIABLES + VAR_DISPLAY_COUNT), a

		PRINT_NUM_FROM_DE

		PRINT_IN_LOOP
		db  60h, 61h, 0FFh			; "point"
									; "of damage"

		ld	a, (GAME_VARIABLES + VAR_TARGET_ID)

		jp	loc_7C4E
