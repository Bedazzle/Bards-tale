proc_gate_closed:
		FIND_INN	0Eh

		CLEAR_INFO_PANEL

		PRINT2_IN_LOOP
		db  21h, 50h, 51h,0FFh			; "You stand before"
										; "the city gates, which are blocked by a gigantic snow drift."
										; "Press a key to head back."

		WAIT_KEY_DOWN

process_exit:
		CLEAR_INFO_PANEL

		ld	hl, GAME_VARIABLES + VAR_FACE_DIRECTION
		ld	a, (hl)
		xor	2
		ld	(hl), a

loc_EECA:
		call	show_compass
		call	do_walk

		jp	dyn_proc_81
