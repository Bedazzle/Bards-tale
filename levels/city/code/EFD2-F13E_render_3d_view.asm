DO_SOME_MOVEMENT:
		GET_GAME_VARIABLE	VAR_FACE_DIRECTION		; ???

		jp	z, loc_F08E

		dec	a
		jp	z, loc_F054

		dec	a
		jp	z, loc_F01A

		ld	hl, GAME_VARIABLES + VAR_39
		ld	a, (GAME_VARIABLES + VAR_COORD_WE_EA)
		sub	3
		call	sub_F0C8
		inc	(iy+VAR_39)
		dec	(hl)
		call	sub_F112
		ld	(byte_FBD7), a
		call	sub_F0E2
		ld	(byte_FBD8), a
		inc	(iy+VAR_39)
		call	sub_F10E
		ld	(byte_FBDA), a
		call	sub_F0F6
		ld	(byte_FBDB), a
		inc	(iy+VAR_39)
		call	sub_F112
		ld	(byte_FBDE), a
		call	sub_F10E
		ld	(byte_FBDD), a

		ret
; -------------------------------------

loc_F01A:
		ld	hl, GAME_VARIABLES + VAR_38
		ld	a, (GAME_VARIABLES + VAR_COORD_SO_NO)
		sub	3
		call	sub_F0D5
		inc	(iy+VAR_38)
		dec	(hl)
		call	sub_F112
		ld	(byte_FBD8), a
		call	sub_F0E2
		ld	(byte_FBD7), a
		inc	(iy+VAR_38)
		call	sub_F10E
		ld	(byte_FBDB), a
		call	sub_F0F6
		ld	(byte_FBDA), a
		inc	(iy+VAR_38)
		call	sub_F112
		ld	(byte_FBDD), a
		call	sub_F10E
		ld	(byte_FBDE), a

		ret
; -------------------------------------

loc_F054:
		ld	hl, GAME_VARIABLES + VAR_39
		ld	a, (GAME_VARIABLES + VAR_COORD_WE_EA)
		add	a, 3
		call	sub_F0C8
		dec	(iy+VAR_39)
		inc	(hl)
		call	sub_F112
		ld	(byte_FBD7), a
		call	sub_F0EC
		ld	(byte_FBD8), a
		dec	(iy+VAR_39)
		call	sub_F10A
		ld	(byte_FBDA), a
		call	sub_F100
		ld	(byte_FBDB), a
		dec	(iy+VAR_39)
		call	sub_F112
		ld	(byte_FBDE), a
		call	sub_F10A
		ld	(byte_FBDD), a

		ret
; -------------------------------------

loc_F08E:
		ld	hl, GAME_VARIABLES + VAR_38
		ld	a, (GAME_VARIABLES + VAR_COORD_SO_NO)
		add	a, 3
		call	sub_F0D5
		dec	(iy+VAR_38)
		inc	(hl)
		call	sub_F112
		ld	(byte_FBD8), a
		call	sub_F0EC
		ld	(byte_FBD7), a
		dec	(iy+VAR_38)
		call	sub_F10A
		ld	(byte_FBDB), a
		call	sub_F100
		ld	(byte_FBDA), a
		dec	(iy+VAR_38)
		call	sub_F112
		ld	(byte_FBDD), a
		call	sub_F10A
		ld	(byte_FBDE), a

		ret

; ======= S U B	R O U T	I N E =========

sub_F0C8:
		ld	(hl), a
		dec	hl
		ld	a, (GAME_VARIABLES + VAR_COORD_SO_NO)
		ld	(hl), a
		call	sub_F112
		ld	(byte_FBD9), a

		ret

; ======= S U B	R O U T	I N E =========

sub_F0D5:
		ld	(hl), a
		inc	hl
		ld	a, (GAME_VARIABLES + VAR_COORD_WE_EA)
		ld	(hl), a
		call	sub_F112
		ld	(byte_FBD9), a

		ret

; ======= S U B	R O U T	I N E =========

sub_F0E2:
		inc	(hl)
		call	sub_F112
		ld	(byte_FBDC), a
		inc	(hl)

		jr	sub_F112

; ======= S U B	R O U T	I N E =========

sub_F0EC:
		dec	(hl)
		call	sub_F112
		ld	(byte_FBDC), a
		dec	(hl)

		jr	sub_F112

; ======= S U B	R O U T	I N E =========

sub_F0F6:
		inc	(hl)
		call	sub_F112
		ld	(byte_FBDF), a
		inc	(hl)

		jr	sub_F112

; ======= S U B	R O U T	I N E =========

sub_F100:
		dec	(hl)
		call	sub_F112
		ld	(byte_FBDF), a
		dec	(hl)

		jr	sub_F112

; ======= S U B	R O U T	I N E =========

sub_F10A:
		inc	(hl)
		inc	(hl)

		jr	sub_F112

; ======= S U B	R O U T	I N E =========

sub_F10E:
		dec	(hl)
		dec	(hl)

		jr	sub_F112

; ======= S U B	R O U T	I N E =========


sub_F112:
		push	hl
		ld	a, (GAME_VARIABLES + VAR_38)
		ld	b, a

		cp	1Eh
		jr	nc, loc_F13C

		ld	a, (GAME_VARIABLES + VAR_39)
		ld	c, a

		cp	1Eh
		jr	nc, loc_F13C

		ld	a, 1Dh
		sub	b
		ld	b, a
		inc	b
		ld	hl, addr_FFE2
		ld	de, 1Eh

loc_F12E:
		add	hl, de
		djnz	loc_F12E

		ld	e, c
		add	hl, de
		ld	c, l
		ld	b, h
		ld	a, 6Eh			; city map address ?
		call	loc_714B
		pop	hl

		ret

loc_F13C:
		pop	hl
		xor	a

		ret
