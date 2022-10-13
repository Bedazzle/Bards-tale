show_name_and_pic:
		call	find_inn

show_pic_by_param:
		call	get_param_to_A

show_pic_by_A:
		inc	(iy+VAR_PAUSE)		; pause ON
		push	af
		xor	a

		cp	(iy+VAR_06)
		ld	(GAME_VARIABLES + VAR_06), a
		call	nz, sub_64FB
		pop	af
		add	a, a
		ld	b, a

		GET_B_FROM_TABLE	0Fh

		ld	e, a
		inc	b

		GET_B_FROM_TABLE	0Fh

		ld	d, a
		ld	hl, addr_4021		; 16417
		exx
		ld	de, 400h		; 1024
		ld	b, e
		ld	c, e
		exx
		call	sub_89AB
		ld	(loc_8960+1), a

loc_8953:
		exx

loc_8954:
		dec	e
		inc	e
		jr	z, loc_895D

		dec	e
		ld	a, h
		exx

		jr	loc_8964
; -------------------------------------

loc_895D:
		call	sub_89AA

loc_8960:
		cp	0				; !!! SMC
		jr	z, loc_899C

loc_8964:
		cpl
		ld	(hl), a			; UNPACKED BYTE	TO SCREEN PICTURE
		call	simple_down_hl
		call	simple_down_hl
		exx
		inc	b
		inc	b
		dec	d
		jr	nz, loc_8974

		ld	d, 4

loc_8974:
		ld	a, b
		sub	56h
		jr	c, loc_8954

		ld	b, a
		inc	c
		ld	d, 4
		exx
		ld	bc, 0E3Fh
		sbc	hl, bc
		exx
		ld	a, c
		sub	0Ah
		jr	nz, loc_8954

		ld	c, a
		inc	b
		ld	a, b
		exx
		ld	bc, addr_FFF6
		add	hl, bc
		call	simple_down_hl

		cp	2
		jr	nz, loc_8953

		dec	(iy+VAR_PAUSE)		; pause OFF

		ret

; -------------------------------------

loc_899C:
		call	sub_89AB
		add	a, 3
		exx
		ld	e, a
		call	sub_89AA
		exx
		ld	h, a

		jr	loc_8954

; ======= S U B	R O U T	I N E =========

sub_89AA:
		exx

sub_89AB:
		ld	a, (de)
		inc	de

		ret
