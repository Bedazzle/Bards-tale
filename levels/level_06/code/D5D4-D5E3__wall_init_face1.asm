; --- wall_init_face1 ($D5D4-$D5E3) ----------------------------------
; @done

wall_init_face1:
		call	unpack_cell_walls
		ld	a,d
		GET_B_FROM_LIST $19
		ld	a,e
		GET_B_FROM_LIST $18
		ld	a,h
		GET_B_FROM_LIST $17
		ret
