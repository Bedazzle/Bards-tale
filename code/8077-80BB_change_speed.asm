change_speed:
		PUSH_REGS

		call	get_param_to_A
		ld	e, 0

loop_speed:
		ld	c, 0A0h
		call	dummy_pause
		ld	hl, GAME_VARIABLES + VAR_58
		push	af
		call	get_pressed_key
		jr	c, set_speed

		dec	e
		inc	e
		jr	z, set_speed

		cp	CODE_ABORT
		jr	z, set_pause

		cp	CODE_C8
		jr	z, check_faster

		cp	CODE_C9
		jr	nz, set_speed

check_slower:
		ld	a, (hl)
		or	a
		jr	z, set_speed

		dec	(hl)

		PRINT_MESSAGE	83h			; "<Slower>"

set_speed:
		ld	a, (hl)

		GET_A_FROM_TABLE	2

		ld	(set_pause_len+1), a
		pop	af
		dec	a
		jr	nz, loop_speed

		and	a

		ret

check_faster:
		ld	a, (hl)

		cp	0Fh
		jr	z, set_speed

		inc	(hl)

		PRINT_MESSAGE	84h			; "<Faster>"

		jr	set_speed
