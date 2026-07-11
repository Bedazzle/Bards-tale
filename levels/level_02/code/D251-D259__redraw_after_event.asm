; --- redraw_after_event ------------------------------------
; @done
; Store A into $5FD2, redraw the view (render_dungeon_view) and clear the info panel.
; In:  a = value stored to ($5FD2).
redraw_after_event:
		ld	(var_5FD2),a
		call	render_dungeon_view
		jp	clear_info_panl
