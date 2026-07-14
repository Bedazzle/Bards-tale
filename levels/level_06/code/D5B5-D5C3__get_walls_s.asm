; --- get_walls_s ($D5B5-$D5C3) ----------------------------------
; @done

get_walls_s:
		inc	(iy+$38)
		call	wrap_view_ns
		call	unpack_cell_walls
		dec	(iy+$38)
		jp	wrap_view_ns
