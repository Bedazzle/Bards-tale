loc_7FF2:
		GET_B_FROM_TABLE	51h

		ld	c, a

		PRINT_IX_HERO_NAME

		CHECK_EQUIPPED	5

		jr	nc, loc_8003

		GET_ATTR_BY_PARAM	CHAR_BARD_SONGS

		jr	z, loc_8061

		dec	(hl)

loc_8003:
		PRINT_MESSAGE	75h			; "plays a tune..."

		inc	(iy+VAR_0F)
		ld	a, c
		call	loc_82E2
		dec	(iy+VAR_0F)

loc_8010:
		GET_GAME_VARIABLE	VAR_10		; ???

		jr	nz, loc_8010

		GET_IY_A_FROM_TABLE	54h, 43h

		dec	c
		jp	m, loc_805A
		jr	z, loc_8055

		dec	c
		jr	z, loc_8045

		dec	c
		jr	z, loc_8039

		dec	c
		jr	z, loc_802F

		ld	hl, GAME_VARIABLES + VAR_60
		ld	a, 2

		jr	sub_805D
; -------------------------------------

loc_802F:
		ld	hl, GAME_VARIABLES + VAR_56
		call	sub_805D

		RST_10_4A

		and	a

		ret
; -------------------------------------

loc_8039:
		push	af
		ld	e, 30h ; '0'
		call	loc_7DBA
		pop	af
		dec	a

		jr	nz, loc_8039

		and	a

		ret
; -------------------------------------

loc_8045:
		ld	b, 3
		ld	c, a

loc_8048:
		GET_B_FROM_TABLE	55h

		add	a, c
		exx
		ld	(hl), a
		exx
		dec	b
		jp	p, loc_8048

		and	a

		ret
; -------------------------------------

loc_8055:
		ld	hl, GAME_VARIABLES + VAR_64
		jr	sub_805D

loc_805A:
		ld	hl, GAME_VARIABLES + VAR_5F

sub_805D:
		add	a, (hl)
		ld	(hl), a
		and	a

		ret

loc_8061:
		PRINT_MESSAGE	76h			; "lost his voice!"

		ret
