show_icon:
		call	get_param_to_A

show_icon_A:
		cp	0Ch
		jr	nz, loc_8D60

		push	af
		xor	a
		ld	(GAME_VARIABLES + VAR_55), a
		ld	(GAME_PARAM_COPY+10h), a
		call	dyn_proc_07
		pop	af

loc_8D60:
		PUSH_REGS

		cp	ICON_SPACE
		jr	nc, extended_sprites

		ld	c, a
		add	a, a

		GET_A_FROM_TABLE	6

		ld	e, a
		exx
		inc	hl
		ld	a, (hl)
		exx
		ld	d, a
		ld	a, c

		jr	search_sprite

extended_sprites:
		sub	8
		add	a, a

		GET_A_FROM_TABLE	6

		ld	e, a
		exx
		inc	hl
		ld	a, (hl)
		exx
		ld	d, a
		ld	a, 9

search_sprite:
		ld hl, ICONS-30h
		ld	bc, 30h		; 48 bytes, 2x3 cells

loop_search_spr:
		add	hl, bc
		dec	a
		jr	nz, loop_search_spr

		ld	b, 18h		; 8x3 = 24 lines to go

sprite_to_screen:
		ld	a, (hl)
		ld	(de), a
		inc	hl
		inc	de

		ld	a, (hl)
		ld	(de), a
		inc	hl
		dec	de

		inc	d
		ld	a, d
		and	7
		jr	nz, loop_scr_cell

		ld	a, e
		add	a, 32
		ld	e, a
		jr	c, loop_scr_cell

		ld	a, d
		sub	8
		ld	d, a

loop_scr_cell:
		djnz	sprite_to_screen

		ret
