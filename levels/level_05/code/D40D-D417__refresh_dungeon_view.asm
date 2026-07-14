; --- refresh_dungeon_view ($D40D-$D417) ----------------------------------
; @done
; Dispatch[1]: redraw the dungeon location view.

refresh_dungeon_view:
		call	clear_txt_buffer
		ld	a,$21
		call	$C2D1
		call	print_loc_name
