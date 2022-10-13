print_msg_A:
		cp	(hl)

print_msg_no_cp:
		exx
		push	af
		ld	a, 1
		ld	c, a
		adc	a, a
		ld	b, a
		dec	b
		pop	af
		ld	(GAME_VARIABLES + VAR_72), ix
		ld	de, 101h
		exx
		and	a
		jr	z, loc_C0A6

		ld	b, 0
		ld	c, a
		add	hl, bc
		push	hl

loc_C084:
		push	hl
		push	af
		ld	a, 5
		ld	c, (hl)
		ld	hl, 0

loc_C08C:
		add	hl, bc
		dec	a
		jr	nz, loc_C08C

		ld	b, 3

loc_C092:
		srl	h
		rr	l
		adc	a, a
		djnz	loc_C092

		and	a
		jr	z, loc_C09D

		inc	hl

loc_C09D:
		add	hl, de
		ex	de, hl
		pop	af
		pop	hl
		dec	hl
		dec	a
		jr	nz, loc_C084

		pop	hl

loc_C0A6:
		ld	c, a
		inc	hl
		push	de
		ld	e, (hl)
		inc	e
		ld	d, a

loc_C0AC:
		exx
		ld	hl, sentence

loc_C0B0:
		exx

loc_C0B1:
		dec	e
		jp	z, loc_C128

		ex	(sp), hl
		ld	b, (hl)
		inc	hl
		ld	a, (hl)
		dec	hl
		ex	(sp), hl
		ld	l, a
		ld	h, b
		dec	c
		inc	c
		jr	z, loc_C0C5

		ld	b, c

loc_C0C2:
		add	hl, hl
		djnz	loc_C0C2

loc_C0C5:
		srl	h
		srl	h
		srl	h
		ld	a, c
		add	a, 5
		ld	c, a
		sub	8
		jr	c, loc_C0D7

		ld	c, a
		ex	(sp), hl
		inc	hl
		ex	(sp), hl

loc_C0D7:
		ld	a, h
		sub	1Dh
		exx
		jr	c, loc_C0E2

		ld	c, b
		inc	a
		ld	b, a

		jr	loc_C0B0
; -------------------------------------

loc_C0E2:
		push	hl
		push	bc

loc_C0E4:
		add	a, 1Dh
		djnz	loc_C0E4
		ld	c, a
		ld	hl, lower_letters
		add	hl, bc
		pop	bc
		ld	a, b

		cp	2
		jr	nz, loc_C0F4

		ld	b, c

loc_C0F4:
		ld	a, (hl)
		pop	hl

		cp	'\'
		jr	z, loc_C10F

		dec	d
		inc	d
		jr	z, loc_C0B0

		ld	(hl), a		; put unpacked letter to buffer
		inc	hl
		exx
		inc	d

		cp	' '
		jr	z, end_of_word

		cp	CODE_CR
		jr	nz, loc_C0B1

end_of_word:
		call	sub_C12D

		jr	loc_C0AC
