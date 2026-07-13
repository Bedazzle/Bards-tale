; --- refresh_dungeon_view ($D51E-$D528) ------------------------
; @done
; Dispatch[1]: redraw the dungeon location view.

refresh_dungeon_view:
		call	clear_txt_buffer
		ld	a,$21			; message $21
		call	print_sewers_flag1
		call	print_loc_name
		; falls through into redraw_location
