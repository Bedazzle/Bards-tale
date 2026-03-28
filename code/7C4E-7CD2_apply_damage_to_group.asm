loc_7C4E:
		PUSH_REGS

		inc	(iy+VAR_PAUSE)		; pause ON
		call	loc_7C5A
		dec	(iy+VAR_PAUSE)		; pause OFF

		ret

loc_7C5A:
		cp	80h
		jr	c, loc_7CD3

		push	hl
		and	7Fh
		ld	c, a
		ld	b, c

		CALC_IN_FB7D

		ex	de, hl

		RST_10_57

		GET_B_FROM_TABLE	36h

		ld	b, a

loc_7C6C:
		bit	0, (hl)
		jr	nz, loc_7C7B

		inc	de
		inc	hl
		djnz	loc_7C6C

		ld	b, c

		CALC_IN_FB7D

		ex	de, hl

		RST_10_57

		ld	b, a

loc_7C7B:
		res	0, (hl)
		ex	(sp), hl
		ex	de, hl
		ld	a, (GAME_VARIABLES + VAR_50)

		cp	6
		jr	nc, loc_7C97

		xor	a
		ld	(GAME_VARIABLES + VAR_50), a

		cp	d
		jr	nz, loc_7C97

		ld	a, (hl)
		sub	e
		jr	z, loc_7C97
		jr	c, loc_7C97

		ld	(hl), a
		and	a
		pop	hl

		ret
; -------------------------------------

loc_7C97:
		pop	de

loc_7C98:
		inc	de
		inc	hl
		ld	a, (de)
		dec	de
		ld	(de), a
		ld	a, (hl)
		dec	hl
		ld	(hl), a
		inc	de
		inc	hl
		djnz	loc_7C98

		GET_C_FROM_TABLE	36h

		dec	a
		exx
		ld	(hl), a
		exx
		jr	nz, loc_7CB1

		xor	a

		GET_C_FROM_LIST	42h

loc_7CB1:
		GET_C_FROM_TABLE	41h

		ld	d, a
		ld	e, 0

loc_7CB7:
		GET_E_FROM_TABLE	2Bh

		jr	z, loc_7CC7

		cp	d
		jr	z, loc_7CC7

		inc	e
		ld	a, e

		cp	10h
		jr      c, loc_7CB7
		jr      loc_7CD1

loc_7CC7:
		ld	a, d
		exx
		ld	(hl), a
		exx

		GET_E_FROM_TABLE	2Ah

		exx
		inc	(hl)
		exx

loc_7CD1:
		scf

		ret
