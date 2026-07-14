; --- process_turn ($DC3C-$DC6B) ----------------------------------
; @done
; Dispatch[2]: end-of-move turn processing (events, combat, view refresh).

process_turn:
		call	show_compass
		ld	a,(iy+$25)
		ld	(iy+$24),a
		call	$C18F
		call	announce_nearby
		call	process_cell_features
		GET_GAME_VARIABLE $3F
		jr	z,.skip
		ld	(iy+$5A),0
		call	combat_foes
		ld	(iy+$3F),0
		call	$C18F
.skip:
		call	clear_txt_buffer
		ld	a,$21
		call	$C2D1
		jp	print_loc_name
