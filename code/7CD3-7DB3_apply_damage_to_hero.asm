loc_7CD3:
		FIND_HERO_BY_A

		jr	z, loc_7CD1

		ld	a, (ix+CHAR_STATUS)

		cp	STATUS_STONED
		jr	z, loc_7CD1

		cp	STATUS_DEAD
		jr	nz, loc_7CEB

		ld	a, (GAME_VARIABLES + VAR_50)	; ???

		cp	5
		jr	z, loc_7CFF

		jr	loc_7CD1

loc_7CEB:
		ex	de, hl

		GET_ATTR_BY_PARAM	CHAR_COND_LO

		sub	e
		ld	(hl), a
		dec	hl
		ld	a, (hl)
		sbc	a, d
		ld	(hl), a
		ld	a, 0
		jr	c, loc_7D28
		jr	nz, loc_7CFF

		inc	hl

		cp	(hl)
		jr	z, loc_7D28

loc_7CFF:
		GET_GAME_VARIABLE	VAR_50			; ???

		jr	z, loc_7D23

		dec	a
		jr	z, loc_7D6F

		dec	a
		jr	z, loc_7D4A

		dec	a
		jr	z, loc_7D6B

		dec	a
		jr	z, loc_7D79

		dec	a
		jp	z, loc_7D9E

		dec	a
		jr	z, loc_7D19

		jr	loc_7D2B
; -------------------------------------

loc_7D19:
		ld	(ix+CHAR_COND_HI), a
		ld	(ix+CHAR_COND_LO), a
		ld	a, 4

		jr	loc_7D37
; -------------------------------------

loc_7D23:
		ld	(GAME_VARIABLES + VAR_50), a
		and	a

		ret
; -------------------------------------

loc_7D28:
		ld	(GAME_VARIABLES + VAR_50), a

loc_7D2B:
		xor	a
		ld	(ix+CHAR_COND_HI), a
		ld	(ix+CHAR_COND_LO), a
		ld	(ix+CHAR_FORMER_HEALTH), a
		ld	a, 3

loc_7D37:
		ld	(ix+CHAR_STATUS), a
		ld	a, (GAME_VARIABLES + VAR_53)
		cp	(iy+VAR_4C)
		call	z, sub_7A67

		RST_10_2E

		jp	c, oh_dear_game_over

loc_7D48:
		scf

		ret
; -------------------------------------

loc_7D4A:
		add	a, b
		jr	z, loc_7D23

		GET_ATTR_BY_PARAM	CHAR_LEVEL_HI

		inc	hl
		ld	a, (hl)
		jr	nz, loc_7D58

		dec	a
		jr	z, loc_7D23

		inc	a

loc_7D58:
		ex	de, hl
		sub	1
		ld	(de), a
		ld	l, a
		dec	de
		ld	a, (de)
		sbc	a, 0
		ld	(de), a
		ld	h, a
		call	loc_76B9
		call	loc_774D
		scf

		ret
; -------------------------------------

loc_7D6B:
		ld	c, 7

		jr	loc_7D71
; -------------------------------------

loc_7D6F:
		ld	c, 1

loc_7D71:
		GET_ATTR_BY_PARAM_SAVE_HL	CHAR_STATUS		; get hero status

		jr	nz, loc_7D48

		ld	a, c

loc_7D77:
		jr	loc_7D37
; -------------------------------------

loc_7D79:
		GET_GAME_VARIABLE	VAR_53		; ???

		jr	z, loc_7D23
		ld	a, (ix+CHAR_STATUS)

		cp	2
		jr	z, loc_7D48

		FIND_ATTR_AND_ADDRESS	CHAR_13

		ex	de, hl

		FIND_ATTR_AND_ADDRESS	CHAR_63

		ld	b, 3

loc_7D8E:
		ld	a, (de)
		ld	(hl), a

		GET_B_FROM_TABLE	4Eh		; ??? CHAR_FORMER_HEALTH ???

		ld	(de), a
		dec	hl
		dec	de
		dec	b
		jp	p, loc_7D8E

		ld	c, 2

		jr	loc_7D71
; -------------------------------------

loc_7D9E:
		ld	(ix+CHAR_COND_HI), a
		ld	a, 64h
		ld	(ix+CHAR_COND_LO), a

		GET_GAME_VARIABLE	VAR_ACTIVE_HERO		; ???

		jr	nc, loc_7DB0

		ld	a, 1
		ld	(ix+CHAR_FORMER_HEALTH), a

loc_7DB0:
		ld	a, 6
		jr	loc_7D77
