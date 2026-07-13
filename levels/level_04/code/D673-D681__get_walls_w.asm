; --- get_walls_w ($D673-$D681) -----------------------------
; @done

get_walls_w:
		dec	(iy+$39)
		call	wrap_view_we
		call	unpack_cell_walls
		inc	(iy+$39)
		jp	wrap_view_we
