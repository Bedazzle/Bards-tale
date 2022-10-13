proc_city_sewers:
		call	DO_SOME_MOVEMENT
		call	loc_F13F

		CLEAR_INFO_PANEL

		FIND_INN	8

		PRINT_MESSAGE2	24h			; "There is an entrance to the city sewers here. Do you wish to take it?"

		PRINT_YES_NO_WAIT

		jr	c, go_city_sewers

		ld	(iy+VAR_COORD_SO_NO),	2

		jp	dyn_proc_81

go_city_sewers:
		ld	hl, 1110h				; TODO: must be loaded from city map data
		ld	(GAME_VARIABLES + VAR_COORD_SO_NO), hl
		ld	(iy+VAR_3B), 3
		ld	b, 0FFh
		ld	c, 7

		jp	insert_skara_tape
