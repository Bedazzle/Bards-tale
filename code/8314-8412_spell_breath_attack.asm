loc_8314:
		xor     a
		ld      (GAME_VARIABLES + VAR_5C), a
		ld      (loc_83E7+1), a
		inc     a
		ld      (GAME_VARIABLES + VAR_65), a
		ld      (iy+VAR_53), 80h
		jr      loc_832F

loc_8325:
		PRINT_MESSAGE	73h			; "breathes"

loc_8328:
		xor	a
		ld	(GAME_VARIABLES + VAR_65), a
		ld	(loc_83E7+1), a

loc_832F:
		GET_GAME_VARIABLE	VAR_ACTIVE_HERO		; ???

		jr	nz, loc_833B

		GET_GAME_VARIABLE	VAR_53		; ???

		jr	c, loc_8349

		jr	loc_8342
; -------------------------------------

loc_833B:
		jr	nc, loc_8349

		ld	a, 0FFh
		ld	(loc_83E7+1), a

loc_8342:
		ld	e, 6

		PRINT_MESSAGE	66h			; "at the party..."

		jr	loc_8383
; -------------------------------------

loc_8349:
		GET_GAME_VARIABLE	VAR_53		; ???

		and	7Fh

		GET_A_FROM_TABLE	36h

		jr	nz, loc_835C

		GET_GAME_VARIABLE	VAR_65		; ???

		jp	z, print_ellipsis

		jp	loc_83EB
; -------------------------------------

loc_835C:
		ld	e, a
		inc	(iy+VAR_5C)

		PRINT_MESSAGE	65h			; "at"

		ld	a, e

		cp	2
		jr	nc, loc_836F

		RST_10_53

		PRINT_MESSAGE	86h			; "..."

		jr	loc_8383
; -------------------------------------

loc_836F:
		PRINT_MESSAGE	67h			; "some"

		ld	(iy+VAR_4F), 1
		ld	a, (GAME_VARIABLES + VAR_53)
		and	7Fh

		GET_A_FROM_TABLE	41h

		PRINT_WORD

		PRINT_MESSAGE	86h			; "..."

loc_8383:
		call	loc_891E
		ld	b, a

		RST_10_49

		RST_10_48

		GET_GAME_VARIABLE	VAR_ACTIVE_HERO		; ???

		jr	c, loc_8398

		jr	nz, loc_83C1

		bit	7, (iy+VAR_53)
		jr	nz, loc_83A8

loc_8398:
		ld	b, e

		FIND_HERO_BY_B

		jr	z, loc_83E5

		CHECK_HERO_STATUS

		jr	nc, loc_83E5

		PRINT_IX_HERO_NAME

		ld	(iy+VAR_53), e

		jr	loc_83AA
; -------------------------------------

loc_83A8:
		RST_10_53

loc_83AA:
		RST_10_2A

		jr	c, loc_83C6

		jr	z, loc_83B6

		srl	h
		rr	l

		jr	loc_83C6
; -------------------------------------

loc_83B6:
		PRINT_IN_LOOP
		db  68h, 47h, 0FFh			; "repelled the"
									; "spell!"

		PRINT_NEWLINE

		RST_10_29

		jr	loc_83E5
; -------------------------------------

loc_83C1:
		PRINT_MESSAGE	2Bh			; "One"

		jr	loc_83AA
; -------------------------------------

loc_83C6:
		PRINT_MESSAGE	82h			; "is"

		call	loc_886D
		add	a, 0B3h

		PRINT_WORD

		PRINT_MESSAGE	81h			; "for"

		SHOW_DAMAGE

		jr	c, loc_83DC

		PRINT_MESSAGE	63h			; ===empty message===

		jr	loc_83E3
; -------------------------------------

loc_83DC:
		ld	a, 0A4h

		PRINT_WORD

		PRINT_MESSAGE	62h			; "him!"

loc_83E3:
		RST_10_29

loc_83E5:
		dec	e
		ld	a, e

loc_83E7:
		cp	0				; !!! SMC
		jr	nz, loc_8383

loc_83EB:
		GET_GAME_VARIABLE	VAR_65

		jr	z, loc_840E

		inc	(iy+VAR_53)
		ld	a, (GAME_VARIABLES + VAR_53)

		cp	84h ; '„'
		jr	z, loc_840E

		and	7Fh

		GET_A_FROM_TABLE	36h

		jr	z, loc_83EB

		GET_GAME_VARIABLE	VAR_5C

		jr	z, loc_840B

		PRINT_NEWLINE

		PRINT_MESSAGE	69h			; "and"

loc_840B:
		jp	loc_8349
; -------------------------------------

loc_840E:
		xor	a
		ld	(GAME_VARIABLES + VAR_65), a

		ret
