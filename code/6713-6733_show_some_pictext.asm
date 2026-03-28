show_some_pictext:
		CLEAR_TXT_BUFFER

		IF_FB98_IS_ZERO

		jr	nz, loc_6721

		ld	a, 91h ; '‘'

		PRINT_EMPTY

		ld	a, 1

		jr	show_pic

loc_6721:
		dec	a
		ld	(GAME_VARIABLES + VAR_DISPLAY_COUNT), a
		ld	a, (ACTIVE_GUARDIAN)
		push	af

		PRINT_EMPTY

		pop	af

		GET_A_FROM_TABLE	INX_MONST_IMAGE

show_pic:
		SHOW_PIC_BY_A

		jp	print_loc_name
