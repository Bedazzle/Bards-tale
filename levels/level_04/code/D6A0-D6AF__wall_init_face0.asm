; --- wall_init_face0 ($D6A0-$D6AF) -------------------------
; @done

wall_init_face0:
		call	unpack_cell_walls
		ld	a,l
		GET_B_FROM_LIST $19
		ld	a,e
		GET_B_FROM_LIST $17
		ld	a,h
		GET_B_FROM_LIST $18
		ret
