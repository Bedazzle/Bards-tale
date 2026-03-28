loc_81D5:
		GET_GAME_VARIABLE	VAR_ACTIVE_HERO		; ???

		jr	c, loc_8207
		jr	z, loc_8207
		ld	d, (ix+CHAR_LEVEL_HI)
		ld	e, (ix+CHAR_LEVEL_LO)

		RST_10_49

loc_81E4:
		push	bc

		RST_10_48

		pop	bc
		dec	de
		ld	a, d
		or	e
		jr	nz, loc_81E4

		jr	loc_820B

; -------------------------------------
loc_81EF:
		ld (iy+VAR_0B), 1
		jr	loc_81FF

loc_81F5:
		ld (iy+VAR_0B), 4
		jr	loc_81FF

loc_81FB:
		ld (iy+VAR_0B), 0

loc_81FF:
		ld (GAME_VARIABLES + VAR_50), a
		ld hl, 0
		jr	loc_820B

; -------------------------------------

loc_8207:
		RST_10_49

		RST_10_48

loc_820B:
		ld	a, (GAME_VARIABLES + VAR_50)
		push	af

		GET_GAME_VARIABLE	VAR_53		; ???

		jr	nz, loc_821E

		GET_GAME_VARIABLE	VAR_ACTIVE_HERO		; ???

		jr	c, loc_821E

		ld	a, 1
		ld	(ENEMY+ENEMY_10), a

loc_821E:
		GET_GAME_VARIABLE	VAR_53		; ???

		jr	c, loc_8237

		FIND_HERO_BY_A

		CHECK_HERO_STATUS

		jr	c, loc_823E

		cp	3
		jr	nz, loc_8233

		pop	af
		push	af

		cp	5
		jr	z, loc_824A

loc_8233:
		pop	af

		jp	print_ellipsis

loc_8237:
		and	7Fh

		GET_A_FROM_TABLE	36h

		jr	z, loc_8233

loc_823E:
		pop	af
		push	af

		cp	5
		jr	nz, loc_824A

		bit	7, (iy+VAR_ACTIVE_HERO)
		jr	z, loc_8233

loc_824A:
		PRINT_MESSAGE	65h			; "at"

		RST_10_53

		RST_10_2A

		jr	c, loc_826E

		or	a
		jr	z, loc_825C

		srl	h
		rr	l

		jr	loc_826E

loc_825C:
		pop	af
		push	af

		cp	5
		jr	nz, loc_8268

		bit	7, (iy+VAR_ACTIVE_HERO)
		jr	z, loc_826E

loc_8268:
		PRINT_MESSAGE	6Ah			; "but it had no effect!"

		pop	af
		and	a

		ret

loc_826E:
		pop	af
		or	a
		jr	nz, loc_8293
		call	loc_886D

		PRINT_MESSAGE	69h			; "and"

		ld	a, b
		add	a, 0ACh

		PRINT_WORD

		PRINT_MESSAGE	80h			; "him for"

		xor	a

		cp	h
		ld	a, l
		jr	z, loc_8286

		inc	a

loc_8286:
		dec	a
		ld	(GAME_VARIABLES + VAR_4F), a
		ex	de, hl

		PRINT_NUM_FROM_DE

		ex	de, hl

		PRINT_IN_LOOP
		db  60h, 61h, 0FFh			; "point"
									; "of damage"

loc_8293:
		ld	a, (GAME_VARIABLES + VAR_53)
		call	loc_7C4E
		jr	c, loc_82B8

		GET_GAME_VARIABLE	VAR_0B		; ???

		jr	z, loc_82B4

		ld	b, a

		GET_GAME_VARIABLE	VAR_ACTIVE_HERO		; ???

		jr	z, loc_82B4

		jr	c, loc_82B4

		ld	a, b
		ld	(iy+VAR_0B), 0
		call	loc_70AF

		PRINT_MESSAGE	62h			; "him!"

		ret

loc_82B4:
		PRINT_MESSAGE	63h			; ===empty message===

		ret

loc_82B8:
		ATTACK_AND_RESULT

		PRINT_MESSAGE	62h			; "him!"

		ret
