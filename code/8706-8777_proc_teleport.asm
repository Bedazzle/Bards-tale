proc_teleport:

		GET_GAME_VARIABLE	VAR_UNDERGROUND

		jr	z, loc_8760

		GET_GAME_VARIABLE	VAR_67		; ???

		jr	nz, loc_8760

		CLEAR_INFO_PANEL

		PRINT_MESSAGE	24h			; "Teleport [Use arrow keys and SPC to select]"

		ld	a, (CITY_MAP_DATA+26Eh)
		or	a
		jr	z, show_down

show_up:
		PRINT_MESSAGE	26h			; "Up   : +"

		jr	wait_teleport

show_down:
		PRINT_MESSAGE	25h			; "Down : +"

wait_teleport:
		ld	(iy+VAR_CURSOR_ROW), 7
		ld	a, (GAME_VARIABLES + VAR_COORD_SO_NO)

		RST_10_45

		ld	c, a
		ld	a, (GAME_VARIABLES + VAR_COORD_WE_EA)

		RST_10_45

		ld	b, a
		ld	a, (GAME_VARIABLES + VAR_3B)

		RST_10_45

		ld	d, a

		PRINT_CRLF_AND_MESSAGE	27h			; "Abort?"

		PRINT_YES_NO_WAIT

		jr	c, loc_876A

		bit	7, d
		jr	nz, loc_876A

		GET_D_FROM_TABLE	58h

		jr	c, loc_876A

		ld	a, d
		add	a, 8

		GET_A_FROM_TABLE	58h

		jr	c, loc_876A

		ld	(GAME_VARIABLES + VAR_COORD_SO_NO), bc
		ld	a, d
		ld	hl, GAME_VARIABLES + VAR_3B

		cp	(hl)
		jr	z, loc_8763

		ld	(hl), d

		jp	loc_876C
; -------------------------------------

loc_8760:
		jp	print_ellipsis
; -------------------------------------

loc_8763:
		call	sub_C192
		xor	a
		ld	(GAME_VARIABLES + VAR_3E), a

loc_876A:
		and	a

		ret
; -------------------------------------

loc_876C:
		GET_IY_A_FROM_TABLE	3Bh, 58h

		add	a, 4
		ld	c, a
		ld	b, 0FFh

		jp	insert_skara_tape
