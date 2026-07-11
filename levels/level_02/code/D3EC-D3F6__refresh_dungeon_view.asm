; --- refresh_dungeon_view ----------------------------------
; @done
; Redraw the dungeon location: clear buffers, print location name,
; ; reset light state, render the current view.
refresh_dungeon_view:
		call	clear_txt_buffer
		ld	a,$21
		call	print_cellars_flag1
		call	print_loc_name
