prep_black_color:
		push	af
		xor	a
		ld	(color_to_draw+1), a
		pop	af

		jr	loc_6501
; -------------------------------------

sub_64FB:
		xor	a
		ld	(color_to_draw+1), a
		ld	a, 39h

loc_6501:
		ld	b, 58h

		jr	draw_city_colors
; -------------------------------------

set_city_colors:
		ld	a, 0Fh		; City view - daytime sky (white ink, dark blue	paper)
		bit	0, (iy+VAR_DAY_PART)
		jr	z, color_set

		ld	a, 7		; City view - nighttime	sky (black)

color_set:
		ld	b, 28h
		ld	(color_to_draw+1), a
		call	draw_city_colors
		ld	a, 17h		; City view - Ground colour (white ink,	red paper)
		ld	(color_to_draw+1), a
		ld	b, 30h

		jr	loc_6526
; -------------------------------------

draw_city_colors:
		ld	de, addr_5821
		ld	hl, addr_4021

loc_6526:
		push	de
		ld	(color_to_drawx+1), a
		ld	a, b
		push	af

loc_652C:
		push	hl
		ld	d, h
		ld	e, l
		inc	de
		ld	bc, 0Ah
		ld	(hl), 0
		ldir

		pop	hl
		push	af
		inc	h
		ld	a, h
		and	7
		jr	nz, loc_6549

		ld	a, l
		add	a, 20h
		ld	l, a
		jr	c, loc_6549

		ld	a, h
		sub	8
		ld	h, a

loc_6549:
		pop	af
		dec	a
		jr	nz, loc_652C

		pop	af
		ex	(sp), hl
		rra
		rra
		rra
		and	1Fh

loc_6554:
		ld	d, h
		ld	e, l
		inc	de
		ld	bc, 0Ah

color_to_drawx:
		ld	(hl), 0			; !!! SMC
		ldir

color_to_draw:
		ld	(hl), 0			; !!! SMC
		ld	bc, 16h
		add	hl, bc
		dec	a
		jr	nz, loc_6554

		ex	de, hl
		pop	hl

		ret
