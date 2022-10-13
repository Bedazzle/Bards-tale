print_A_symbol:
		push	af
		ld	a, (GAME_VARIABLES + VAR_CURSOR_ROW)
		ld	c, a
		and	18h
		add	a, 40h
		ld	h, a
		ld	a, c
		rrca
		rrca
		rrca
		and	0E0h
		ld	l, a
		ld	a, (GAME_VARIABLES + VAR_CURSOR_COL)
		ld	c, a
		ld	b, 5

mult_by_6:
		add	a, c
		djnz	mult_by_6

		ld	e, a		; A = pixel X
		srl	e
		srl	e
		srl	e			; E = cell X
		ld	d, 0
		add	hl, de
		ex	de, hl		; HL = scr addr
		and	7
		inc	a
		ld	c, a
		pop	af			; restore symbol to print
		ld	hl, SYMBOL_EMPTY

		cp	'`'			; 60h
		jr	z, symbol_to_scren

		ld	hl, SYMBOL_CROSS

		cp	'|'			; 7Ch
		jr	z, symbol_to_scren

		ld	hl, SYMBOL_ZERO

		cp	'^'			; 5Eh
		jr	z, symbol_to_scren

print_regular:
		sub	' '
		ld	l, a
		ld	h, 0
		add	hl, hl
		add	hl, hl
		add	hl, hl
		ld	a, h
		add	a, 3Dh 		; '='    ; ROM font starts at 3D00 (space symbol)
		ld	h, a

symbol_to_scren:
		push	hl
		ld	hl, 81FFh	; 81h =	1000 0001
		ld	b, c

scroll_mask:
		sra	h
		rr	l
		djnz	scroll_mask

		adc	hl, hl
		adc	hl, hl
		ex	(sp), hl
		ld	a, 8

symbl_next_byte:
		ex	af, af'
		ex	(sp), hl
		ex	de, hl
		ld	a, d
		and	(hl)
		ld	(hl), a			; PUT TO SCREEN
		ld	a, e
		inc	hl
		and	(hl)
		ld	(hl), a
		dec	hl
		ex	de, hl
		ex	(sp), hl
		ld	a, (hl)
		inc	hl
		push	hl
		and	7Eh ; '~'       ; 7Eh = 0111 1110
		sla	a
		ld	h, a
		xor	a
		ld	b, c

scroll_sprite:
		srl	h
		rra
		djnz	scroll_sprite

		ld	l, a
		add	hl, hl
		ex	de, hl
		ld	a, d
		or	(hl)
		ld	(hl), a
		inc	hl
		ld	a, e
		or	(hl)
		ld	(hl), a
		dec	hl
		inc	h
		ex	de, hl
		pop	hl
		ex	af, af'
		dec	a
		jr	nz, symbl_next_byte

		pop	de

		ret
