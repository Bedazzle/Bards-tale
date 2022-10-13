loc_7967:
		ld	b, 0

		FIND_HERO_BY_B

		jr	z, loc_7987

		GET_GAME_VARIABLE	VAR_66			; ???

		jr	nz, loc_7985

		GET_ATTR_BY_PARAM	CHAR_COND_HI

		jr	nz, loc_797B

		inc	hl

		cp	(hl)
		jr	z, loc_7985

loc_797B:
		ld	a, (ix+CHAR_STATUS)		; Character status
		sub	3
		jr	z, loc_7985

		dec	a
		jr	nz, loc_7987

loc_7985:
		CLEAN_ALLY_MEMORY

loc_7987:
		RST_10_2E

		ret	c

		inc	b
		ld	c, b
		ld	b, 1

loc_798E:
		FIND_HERO_BY_B

		CHECK_HERO_STATUS

		jr	c, loc_79EB

		ld	a, b

		cp	(iy+VAR_4C)
		jr	nc, loc_799D

		dec	(iy+VAR_4C)

loc_799D:
		cp	6
		jr	z, loc_79B4

loc_79A1:
		ld	hl, addr_92C9
		inc	b
		ld	e, 3

loc_79A7:
		ld	a, (hl)
		inc	hl
		call	loc_66EC
		dec	e
		jr	nz, loc_79A7

		ld	a, b
		inc	a

		cp	c
		jr	c, loc_79A1

loc_79B4:
		xor	a

		GET_B_FROM_LIST	45h

		GET_B_FROM_LIST	30h

		GET_B_FROM_LIST	2Fh

loc_79BE:
		GET_ATTR_BY_PARAM_SAVE_HL	CHAR_POS_IN_PARTY

		cp	6					; last one
		jr	z, loc_79D5

		push	ix
		pop	hl
		inc	a

		FIND_HERO_BY_A

		push	ix
		pop	de
		ld	a, 64h ; 'd'
		call	swap_byte_buffer

		jr	loc_79BE

loc_79D5:
		GET_ATTR_BY_PARAM_SAVE_HL	CHAR_NEG_FLAG

		call	nz, clean_hero_memory
		push	ix
		call	is_roster_full
		pop	de
		push	ix
		pop	hl
		ld	a, 64h ; 'd'
		call	swap_byte_buffer

		jr	loc_7987
; -------------------------------------

loc_79EB:
		inc	b
		ld	a, b

		cp	c
		jr	c, loc_798E

loc_79F0:
		RST_10_5D

		jr	c, loc_7A00
		ld	(iy+VAR_4D), b

loc_79F7:
		GET_B_FROM_TABLE	36h

		jr	z, loc_7A02

		dec	b
		jp	p, loc_79F7

loc_7A00:
		and	a

		ret
; -------------------------------------

loc_7A02:
		CALC_IN_FB7D

		ex	de, hl
		inc	b
		ld	a, b

		cp	4
		jr	nc, loc_7A23

		CALC_IN_FB7D

		ld	a, 64h 		; 'd'
		call	swap_byte_buffer

		ld	a, 36h 		; '6'
		call	loc_66EC

		ld	a, 41h 		; 'A'
		call	loc_66EC

		ld	a, 57h 		; 'W'
		call	loc_66EC

		jr	loc_7A02
; -------------------------------------

loc_7A23:
		dec	b
		xor	a

		GET_B_FROM_LIST	36h

		GET_B_FROM_LIST	41h

		ld	b, 64h ; 'd'

loc_7A2D:
		ld	(hl), a
		djnz	loc_7A2D

		jr	loc_79F0
