; --- proc_city_sewers ---------------------------------------
; @done
; City location handler for the sewer-entrance tile. Runs the
; normal step + redraw, clears the info panel, names the nearby
; inn (id 8) and asks the party whether to descend. On "yes" it
; sets the sewer entry coords / teleport mode and loads the sewer
; level tape; on "no" it hands back to the map walker.
; Note: entered via the dynamic location-procedure dispatch (iy = game vars).
proc_city_sewers:
		call	DO_SOME_MOVEMENT
		call	display_walls_creatures

		CLEAR_INFO_PANEL

		FIND_INN	8

		PRINT_MESSAGE2	$24			; "There is an entrance to the city sewers here. Do you wish to take it?"

		PRINT_YES_NO_WAIT

		jr	c,go_city_sewers

		ld	(iy+VAR_COORD_SO_NO),2

		jp	dispatch_movement

go_city_sewers:
		ld	hl,$1110				; TODO: must be loaded from city map data
		ld	(GAME_VARIABLES + VAR_COORD_SO_NO),hl
		ld	(iy+VAR_TELEPORT_MODE),3
		ld	b,$FF
		ld	c,7

		jp	insert_skara_tape
