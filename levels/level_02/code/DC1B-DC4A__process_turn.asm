; --- process_turn ------------------------------------------
; @done
; Dispatch[2]: end-of-move turn processing. Show the compass, refresh the view (via
; the $C18F vector), announce nearby features, apply the cell's specials, roll a
; random combat (combat_foes on game var $3F), then redraw the location.
process_turn:
		call	show_compass
		ld	a,(iy+$25)
		ld	(iy+$24),a
		call	redraw_vector
		call	announce_nearby
		call	process_cell_features
		GET_GAME_VARIABLE $3f
		jr	z,.redraw
		ld	(iy+$5a),0
		call	combat_foes
		ld	(iy+$3f),0
		call	redraw_vector
.redraw:
		call	clear_txt_buffer
		ld	a,$21
		call	print_cellars_flag1
		jp	print_loc_name

