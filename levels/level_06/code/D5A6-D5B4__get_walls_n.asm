; --- get_walls_n ($D5A6-$D5B4) ----------------------------------
; @done

get_walls_n:
		dec	(iy+$38)
		call	wrap_view_ns
		call	unpack_cell_walls
		inc	(iy+$38)
		jp	wrap_view_ns
