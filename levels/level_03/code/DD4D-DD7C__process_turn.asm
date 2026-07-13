; --- process_turn ($DD4D-$DD7C) --------------------------------
; @done
; Dispatch[2]: end-of-move turn processing (events, combat, view refresh).

process_turn:
		call	show_compass
		ld	a,(iy+$25)
		ld	(iy+$24),a		; snapshot the move state
		call	redraw_vector
		call	announce_nearby
		call	process_cell_features
		GET_GAME_VARIABLE $3F		; a combat got triggered this turn?
		jr	z,.show_name
		ld	(iy+$5A),0
		call	combat_foes
		ld	(iy+$3F),0
		call	redraw_vector
.show_name:
		call	clear_txt_buffer
		ld	a,$21			; message $21
		call	print_sewers_flag1
		jp	print_loc_name
