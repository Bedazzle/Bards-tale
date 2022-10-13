print_from_buffer:
		exx
		push	de
		exx
		ld	hl, sentence
		push	af
		ex	af, af'
		ld	a, (hl)

		cp	'.'
		jr	z, same_row

		cp	','
		jr	z, same_row

		ld	a, (GAME_VARIABLES + VAR_CURSOR_COL)
		add	a, d

		cp	29h			; 41
		jr	c, same_row

		PRINT_NEWLINE

same_row:
		ld	a, (hl)
		inc	hl
		call	prnt_with_codes
		dec	d
		jr	nz, same_row

		pop	af
		ex	af, af'
		exx
		pop	de
		exx
		and	a

		ret
