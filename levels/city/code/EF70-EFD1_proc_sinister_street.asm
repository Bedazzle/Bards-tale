proc_sinistr_strt:
		call	sub_EFC1
		ld	hl, (GAME_VARIABLES + VAR_COORD_SO_NO)
		ld	(GAME_VARIABLES + VAR_38), hl
		call	sub_F112
		jr	nz, loc_EFA3

		FIND_INN	4

sinister_teleport:
		CLEAR_INFO_PANEL

		ld	a, (GAME_VARIABLES + VAR_FACE_DIRECTION)
		add	a, 0BAh
		ld	e, a
		call	loc_86A3
		call	DO_SOME_MOVEMENT
		ld	hl, (GAME_VARIABLES + VAR_COORD_SO_NO)
		ld	a, l

		cp	2
		jr	nz, no_teleport

		ld	a, h

		cp	19h
		jr	nz, no_teleport

		ld	(iy+VAR_COORD_SO_NO),	7	; throw party to another location

no_teleport:
		jp	loc_F13F
; -------------------------------------

loc_EFA3:
		call	divide_A_by_8

		cp	0Dh
		jr	nz, loc_EFB5

		ld	b, 6

loc_EFAC:
		CHECK_EQUIPPED	0Fh

		jr	nc, sinister_teleport
		djnz	loc_EFAC

		ld	a, 0Dh

loc_EFB5:
		add	a, a
		ld	b, a

		GET_B_FROM_TABLE	0Ah

		ld	l, a
		inc	b

		GET_B_FROM_TABLE	0Ah

		ld	h, a

		jp	(hl)

; ======= S U B	R O U T	I N E =========


sub_EFC1:
		GET_GAME_VARIABLE	VAR_10		; ???

		ret	nz

		GET_GAME_VARIABLE	VAR_2E		; ???

		ret	nz

		ld	de, 2		; duration
		ld	hl, 1		; pitch

		jp	call_beeper
