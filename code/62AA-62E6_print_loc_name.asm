print_loc_name:
		inc	(iy+VAR_PAUSE)		; pause ON
		ld	hl, (GAME_VARIABLES + VAR_CURSOR_ROW)
		push	hl
		call	sub_6D38
		ld	hl, TEXT_BUFFER
		push	hl
		xor	a

loc_62B9:
		bit	7, (hl)
		jr	nz, loc_62C3

		inc	hl
		inc	a

		cp	0Dh
		jr	nz, loc_62B9

loc_62C3:
		srl	a
		sub	6
		neg
		add	a, 1
		ld	(GAME_VARIABLES + VAR_CURSOR_COL), a
		ld	b, 0Dh
		pop	hl

loc_62D1:
		ld	a, (hl)
		or	a
		jp	m, loc_62DB

		PRINT_WITH_CODES

		inc	hl
		djnz	loc_62D1

loc_62DB:
		pop	hl
		ld	(GAME_VARIABLES + VAR_CURSOR_ROW), hl
		ld	ix, (GAME_VARIABLES + VAR_41)
		dec	(iy+VAR_PAUSE)		; pause OFF

		ret
