print_stats_table:
		GET_GAME_VARIABLE	VAR_12		; ???

		jr	z, loc_8AF3

		inc	(iy+VAR_13)

		ret

loc_8AF3:
		push	ix
		inc	(iy+VAR_PAUSE)		; pause ON
		ld	hl, 1800h
		ld	(GAME_VARIABLES + VAR_INFO_COL_POS),	hl
		ld	hl, (GAME_VARIABLES + VAR_CURSOR_ROW)
		push	hl
		ld	hl, GAME_VARIABLES + VAR_CURSOR_ROW
		ld	(hl), 11h		; set row
		inc	hl
		ld	c, 7			; 6 heroes count + ally
		ld	b, 0

loc_8B0C:
		push	bc
		ld	(hl), 3			; set column

		FIND_HERO_BY_B

		jr	z, loc_8B65

		PRINT_IX_HERO_NAME

		ld	a, 12h
		call	print_spaces_eol
		ld	a, (ix+CHAR_NATURAL_AC)

		cp	15h
		jr	c, loc_8B23

		ld	a, 14h

loc_8B23:
		add	a, a
		inc	(hl)

		PRINT_LETTER_PAIR

		ld	a, (ix+CHAR_COND_LO)
		or	(ix+CHAR_COND_HI)
		jr	nz, loc_8B38

		GET_ATTR_BY_PARAM_SAVE_HL	CHAR_STATUS

		jr	nz, loc_8B38

		ld	(ix+CHAR_STATUS), STATUS_DEAD

loc_8B38:
		GET_ATTR_BY_PARAM_SAVE_HL	CHAR_STATUS

		jr	z, loc_8B4C

		inc	(hl)
		add	a, a
		add	a, a
		add	a, 42h			; statuses
		push	af

		PRINT_LETTER_PAIR	; two first letters of status

		pop	af
		add	a, 2

		PRINT_LETTER_PAIR	; following two letters of status

		jr	loc_8B50
; -------------------------------------

loc_8B4C:
		ld	a, CHAR_HITS_LO

		PRINT_HERO_ATTR

loc_8B50:
		ld	a, CHAR_COND_LO

		PRINT_HERO_ATTR

		ld	a, CHAR_SPPT_LO

		PRINT_HERO_ATTR

		GET_ATTR_BY_PARAM_SAVE_HL	CHAR_CLASS

		jr	nc, loc_8B5F

		ld	a, 0Ah

loc_8B5F:
		add	a, a
		add	a, 2Ah			; classes
		inc	(hl)

		PRINT_LETTER_PAIR

loc_8B65:
		GET_GAME_VARIABLE	VAR_CURSOR_COL

		jr	z, loc_8B6E

		PRINT_SPACE

		jr	loc_8B65
; -------------------------------------

loc_8B6E:
		pop	bc
		inc	b
		dec	c
		jr	nz, loc_8B0C

		pop	hl
		ld	(GAME_VARIABLES + VAR_CURSOR_ROW), hl

loc_8B77:
		ld	hl, 0E15h
		ld	(GAME_VARIABLES + VAR_INFO_COL_POS),	hl
		pop	ix
		dec	(iy+VAR_PAUSE)		; pause OFF

		ret
