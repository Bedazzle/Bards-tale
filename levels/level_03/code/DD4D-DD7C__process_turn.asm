; --- process_turn ($DD4D-$DD7C) --------------------------------
; @wip
; Dispatch[2]: end-of-move turn processing (events, combat, view refresh).

process_turn:
		call	show_compass
		ld	a,(iy+$25)
		ld	(iy+$24),a
		call	$c18f
		call	announce_nearby
		call	process_cell_features
		GET_GAME_VARIABLE $3f
		jr	z,.dd72
		ld	(iy+$5a),0
		call	combat_foes
		ld	(iy+$3f),0
		call	$c18f
.dd72:
		call	clear_txt_buffer
		ld	a,$21
		call	print_sewers_flag1
		jp	print_loc_name
