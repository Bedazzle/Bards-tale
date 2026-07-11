; --- change_speed ---------------------------------------------
; @done
; Paces text/combat output and lets the player retune the scroll
; speed on the fly. For a parameter-supplied number of delay steps it
; waits one dummy_pause tick per step while polling the keyboard: the
; faster/slower keys adjust VAR_COMBAT_SPEED (clamped 0..$0F, printing
; <Faster>/<Slower>), CODE_ABORT drops into set_pause, and any other
; key (or a keypress via get_pressed_key carry) ends the wait early.
; The current speed indexes delay-table 2, whose value patches the
; pause length stored at set_pause_len+1.
; In:  step count via get_param_to_A; iy = game variables
; Out: a = 0, NC
; Note: self-modifies set_pause_len+1 with the per-step delay length.
change_speed:
		PUSH_REGS

		call	get_param_to_A
		ld	e,0

loop_speed:
		ld	c,$A0
		call	dummy_pause
		ld	hl,GAME_VARIABLES + VAR_COMBAT_SPEED
		push	af
		call	get_pressed_key
		jr	c,set_speed

		dec	e
		inc	e
		jr	z,set_speed

		cp	CODE_ABORT
		jr	z,set_pause

		cp	CODE_C8
		jr	z,check_faster

		cp	CODE_C9
		jr	nz,set_speed

check_slower:
		ld	a,(hl)
		or	a
		jr	z,set_speed

		dec	(hl)

		PRINT_MESSAGE	$83			; "<Slower>"

set_speed:
		ld	a,(hl)

		GET_A_FROM_TABLE	2

		ld	(set_pause_len+1),a
		pop	af
		dec	a
		jr	nz,loop_speed

		and	a

		ret

check_faster:
		ld	a,(hl)

		cp	$0F
		jr	z,set_speed

		inc	(hl)

		PRINT_MESSAGE	$84			; "<Faster>"

		jr	set_speed
