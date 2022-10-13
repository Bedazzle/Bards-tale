prnt_next_digit:
		inc	a

print_digit:
		add	a, '0'    ; A=number to print

		jr	prnt_with_codes

; -------------------------------------

print_2newlines:
		PRINT_NEWLINE

print_newline:
		ld	a, CODE_CR

		jr	prnt_with_codes
; -------------------------------------

print_num_from_E:
		ld	d, 0

print_num_from_DE:
		call	print_number

print_space:
		ld	a, 20h ; ' '

prnt_with_codes:
		PUSH_REGS

		ld	hl, GAME_VARIABLES + VAR_CURSOR_COL

		cp	CODE_CR
		jr	z, print_crlf

		cp	CODE_C8
		ret	nc

		cp	' '
		jr	nz, regular_symbol

space:
		ld	e, a
		ld	a, (hl)
		cp	(iy+VAR_INFO_COL_POS)
		ld	a, e
		ret	z

regular_symbol:
		cp	','
		jr	z, dot_or_comma

		cp	'.'
		jr	nz, letter_symbol

dot_or_comma:
		ex	af, af'
		ld	a, (hl)

		cp	15h
		ret	z

		ex	af, af'

letter_symbol:
		push	hl
		call	print_A_symbol
		pop	hl
		inc	(hl)		; change cursor	position
		ld	a, (hl)

		cp	29h ; ')'       ; 29h = 41 dec  ??? symbols in row ???
		ret	c

print_crlf:
		ld	a, (GAME_VARIABLES + VAR_INFO_COL_POS)
		ld	(hl), a
		dec	hl
		inc	(hl)
		ld	a, (hl)

		cp	(iy+VAR_48)
		ret	z
		ret	c

		dec	(hl)
		ld	hl, addr_408F
		ld	de, addr_406F
		ld	a, 0Bh

copy_11_rows:
		ex	af, af'
		ld	a, 8

copy_8_lines:
		ld	bc, 11h
		push	hl
		push	de
		ldir

		pop	de
		pop	hl
		inc	h
		inc	d
		dec	a
		jr	nz, copy_8_lines

		ld	a, l
		add	a, 20h ; ' '
		ld	l, a
		jr	c, after_decrease

		ld	a, h
		sub	8
		ld	h, a

after_decrease:
		ld	a, e
		add	a, 20h ; ' '
		ld	e, a
		jr	c, loc_8BFE

		ld	a, d
		sub	8
		ld	d, a

loc_8BFE:
		ex	af, af'
		dec	a
		jr	nz, copy_11_rows

		PRINT_SPACE_LINE

set_pause_len:
		ld	c, 14h

		jp	dummy_pause
