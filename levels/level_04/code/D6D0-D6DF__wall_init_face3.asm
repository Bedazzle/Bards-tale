; --- wall_init_face3 ($D6D0-$D6DF) -------------------------
; @done

wall_init_face3:
		call	unpack_cell_walls
		ld	a,l
		GET_B_FROM_LIST $17
		ld	a,d
		GET_B_FROM_LIST $18
		ld	a,h
		GET_B_FROM_LIST $19
		ret
