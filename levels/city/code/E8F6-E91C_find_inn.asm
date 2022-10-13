find_inn:
		call	get_param_to_A
		add	a, 34h
		ld	(default_inn + 2), a
		ld	hl, inns_data

check_inn_id:
		ld	a, (hl)

		cp	(iy+VAR_COORD_SO_NO)
		inc	hl
		ld	a, (hl)
		inc	hl
		inc	hl
		jr	nz, check_last_inn

		cp	(iy+VAR_COORD_WE_EA)
		jr	z, found_inn

check_last_inn:
		cp	0FFh
		jr	nz, check_inn_id

found_inn:
		dec	hl
		ld	a, (hl)

		CLEAR_TXT_BUFFER

		PRINT2_A_WITH_FLAG_1

		jp	print_loc_name
