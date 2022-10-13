loc_662A:
		CLEAR_INFO_PANEL

		RST_10_5D

		ld	hl, 150Eh
		ld	(GAME_VARIABLES + VAR_CURSOR_ROW), hl
		jr	nc, loc_663E

		PRINT_MESSAGE	0Bh			; "There is dissention in your ranks.."

		CHANGE_SPEED 0Ah

		jr	loc_6696
; -------------------------------------

loc_663E:
		PRINT_MESSAGE	23h			; "You face"

		PRINT_MESSAGE	43h			; "death itself, in the form of:"


loc_6644:
		IF_FB98_IS_ZERO

		jr	nz, loc_664F

		PRINT_MESSAGE	59h			; "hostile party members!"

		CHANGE_SPEED 8

		ret
; -------------------------------------

loc_664F:
		ld	c, 0

loc_6651:
		GET_C_FROM_TABLE	36h

		ld	e, a

		PRINT_NUM_FROM_E

		dec	e
		ld	(iy+VAR_4F), e

		GET_C_FROM_TABLE	41h

		PRINT_WORD

		inc	c
		ld	a, (GAME_VARIABLES + VAR_CURSOR_COL)
		cp	15h
		jr	nz, loc_666F
		dec	(iy+VAR_CURSOR_ROW)
		ld	(iy+VAR_CURSOR_COL), 29h	; 41

loc_666F:
		ld	a, c
		cp	4
		jr	z, loc_6696

		GET_C_FROM_TABLE	36h

		jr	z, loc_6696

		ld	a, 2Ch ; ','

		PRINT_WITH_CODES

		ld	a, c
		cp	3
		jr	z, loc_6688
		inc	a

		GET_A_FROM_TABLE	36h

		jr	nz, loc_668B

loc_6688:
		PRINT_MESSAGE	69h			; "and"

loc_668B:
		ld	a, (GAME_VARIABLES + VAR_CURSOR_COL)
		cp	1Ah
		jr	c, loc_6651

		PRINT_NEWLINE

		jr	loc_6651
; -------------------------------------

loc_6696:
		PRINT_MESSAGE	63h			; ===empty message===

		ret
