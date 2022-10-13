option_is_found:
		GET_E_FROM_TABLE	39h

		jr	z, loc_691D

		and	c
		jr	z, loop_option

loc_691D:
		inc	e
		ld	a, e

		GET_B_FROM_LIST	56h

		cp	4
		jr	nz, loc_6954

		push	bc
		call	use_which_item
		pop	bc
		jr	z, loc_6963
		jr	c, battle_cant_use

		push	af
		ld	a, l

		GET_B_FROM_LIST	3Ah

		pop	af
		and	7Fh

		cp	10h
		jr	c, battle_cant_use

		GET_A_FROM_TABLE	6Ah

		GET_B_FROM_LIST	51h

		ld	(GAME_VARIABLES + VAR_4B), a
		call	loc_6A03
		jr	nc, loc_6963

		GET_B_FROM_LIST	3Bh

		jp	loc_69D2

; -------------------------------------

battle_cant_use:
		PRINT_MESSAGE	11h			; "You can't use that."

		jr	loc_6961
; -------------------------------------

loc_6954:
		cp	3
		jr	nz, loc_6977

		ld	a, 8
		ld	c, 8
		call	loc_7545
		jr	nc, loc_6966

loc_6961:
		CHANGE_SPEED_TO_8

loc_6963:
		jp	loc_6896
; -------------------------------------

loc_6966:
		ld	a, (GAME_VARIABLES + VAR_4B)

		GET_B_FROM_LIST	3Ch

		call	loc_6A03
		jr	nc, loc_6963

loc_6971:
		GET_B_FROM_LIST	51h

		jp	loc_69D2
