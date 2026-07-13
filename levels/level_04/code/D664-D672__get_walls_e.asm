; --- get_walls_e ($D664-$D672) -----------------------------
; @done

get_walls_e:
		inc	(iy+$39)
		call	wrap_view_we
		call	unpack_cell_walls
		dec	(iy+$39)
		jp	wrap_view_we
