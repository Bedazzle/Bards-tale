loc_8649:
		ld      a, (GAME_VARIABLES + VAR_FACE_DIRECTION)
		add     a, 0BAh ; '¦'
		ld      e, a
		ld      hl, GAME_VARIABLES + VAR_4F

		CLEAR_INFO_PANEL

		GET_GAME_VARIABLE	VAR_UNDERGROUND

		jr	z, loc_869A
		call	loc_86A3

		PRINT_MESSAGE	6Dh			; "and are"

		ld	a, (GAME_VARIABLES + VAR_3B)
		ld	(hl), a
		dec	(hl)

		PRINT_DIGIT

		PRINT_MESSAGE	6Eh			; "level"

		ld	a, (CITY_MAP_DATA+26Eh)
		or	a
		jr	z, loc_8674

		PRINT_MESSAGE	70h			; "above,"

		jr	loc_8677

loc_8674:
		PRINT_MESSAGE	6Fh			; "below,"

loc_8677:
		ld	e, (iy+VAR_COORD_SO_NO)
		ld	(hl), e
		dec	(hl)

		PRINT_NUM_FROM_E

		PRINT_MESSAGE	71h			; "square"

		ld	a, 0BAh

		PRINT_WORD

		PRINT_SPACE

		ld	e, (iy+VAR_COORD_WE_EA)
		ld	(hl), e
		dec	(hl)

		PRINT_NUM_FROM_E

		PRINT_MESSAGE	71h			; "square"

		ld	a, 0BBh

		PRINT_WORD

		PRINT_MESSAGE	72h			; "of the entry stairs."

		jr	loc_86A0
; -------------------------------------

loc_869A:
		call	loc_86A3

		PRINT_MESSAGE	74h			; "in Skara Brae."

loc_86A0:
		jp	print_and_wait
; -------------------------------------

loc_86A3:
		PRINT_MESSAGE	23h			; "You face"

		ld	a, e

		jp	print_word
