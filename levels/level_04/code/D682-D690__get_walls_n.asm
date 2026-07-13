; --- get_walls_n ($D682-$D690) -----------------------------
; @done

get_walls_n:
		dec	(iy+$38)
		call	wrap_view_ns
		call	unpack_cell_walls
		inc	(iy+$38)
		jp	wrap_view_ns
