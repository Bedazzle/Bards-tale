battle_play_tune:
		cp	6
		jr	nz, loc_69D2

		CLEAR_INFO_PANEL

		PRINT_CRLF_AND_MESSAGE	1	; "Play tune"

		PRINT_MESSAGE	44h			; "(1-6)"

enter_tune_number:
		ENTER_1_TO_6

		jr	nc, play_chosen_tune

		cp	0EAh
		jr	z, loc_6963

		jr	enter_tune_number

play_chosen_tune:
		dec	a

		GET_B_FROM_LIST	51h

loc_69D2:
		GET_ATTR_BY_PARAM_SAVE_HL	CHAR_NEG_FLAG

		jr	z, loc_69DC

		ld	a, 8

		GET_B_FROM_LIST	56h

loc_69DC:
		inc	b
		ld	a, b

		cp	7
		jp	c, loc_6896

loc_69E3:
		CLEAR_INFO_PANEL

		PRINT_MESSAGE	0Ah			; "Use these commands?"

		PRINT_YES_NO_WAIT

		jp	nc, party_fight

		ld	b, 7
		ld	hl, addr_FF74

loc_69F2:
		ld	a, (hl)

		cp	7
		jr	nz, loc_69F9

		ld	(hl), 1

loc_69F9:
		dec	hl
		djnz	loc_69F2

		CLEAR_INFO_PANEL

		ld	(iy+VAR_CURSOR_ROW), 0Eh

		ret
