loc_8413:
		call	loc_6A66
		jr	nc, loc_8433

		bit	7, (iy+VAR_ACTIVE_HERO)
		jr	z, loc_8426

		inc	(iy+VAR_61)

		PRINT_MESSAGE	6Bh			; "and the party misses an attack"

		jr	loc_8453

loc_8426:
		ld	a, (GAME_VARIABLES + VAR_53)
		and	7Fh

		GET_A_FROM_TABLE	1

		exx
		inc	(hl)
		exx

		jr	loc_8453

loc_8433:
		PRINT_MESSAGE	6Ah			; "but it had no effect!"

		ret

; -------------------------------------

loc_8437:
		GET_B_FROM_TABLE	22h

		ld	c, a

		GET_GAME_VARIABLE	VAR_ACTIVE_HERO		; ???

		jr	c, loc_844B

		ld	a, (GAME_VARIABLES + VAR_53)
		and	7Fh

		GET_A_FROM_TABLE	2Eh

		jp	loc_86C0

loc_844B:
		ld	hl, GAME_VARIABLES + VAR_63
		ld	a, c
		add	a, (hl)
		ld	(hl), a

		RST_10_4A

loc_8453:
		jp	print_ellipsis

; -------------------------------------

loc_8456:
		GET_B_FROM_TABLE	21h

		ld	c, a

		GET_IY_A_FROM_TABLE	52h, 45h

		call	loc_86C0

		jp	dyn_proc_07

; -------------------------------------

loc_8464:
		GET_B_FROM_TABLE	5Dh

		ld	c, a

		GET_GAME_VARIABLE	VAR_ACTIVE_HERO		; ???

		jr	c, loc_8477
		ld	a, c
		ld	hl, GAME_VARIABLES + VAR_56
		add	a, (hl)
		ld	(hl), a

		RST_10_4A

		jr	loc_8453
; -------------------------------------

loc_8477:
		and	7Fh

		GET_A_FROM_TABLE	2Eh

		sub	c
		exx
		ld	(hl), a
		exx

		jr	loc_8453
; -------------------------------------

loc_8482:
		jr	c, loc_8489

		call	loc_8497

		jr	loc_8453
; -------------------------------------

loc_8489:
		ld	b, 6

loc_848B:
		ld	(iy+VAR_53), b
		call	loc_8497
		dec	b
		jp	p, loc_848B

		jr	loc_8453
