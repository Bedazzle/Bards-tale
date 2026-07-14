; --- wall_init_face2 ($D565-$D574) ----------------------------------
; @done

wall_init_face2:
		call	unpack_cell_walls
		ld	a,l
		GET_B_FROM_LIST $18
		ld	a,d
		GET_B_FROM_LIST $17
		ld	a,e
		GET_B_FROM_LIST $19
		ret
