; --- get_walls_n ($D527-$D535) ----------------------------------
; @done

get_walls_n:
		dec	(iy+$38)
		call	wrap_view_ns
		call	unpack_cell_walls
		inc	(iy+$38)
		jp	wrap_view_ns
