loc_656A:
		ZERO_BUFFERS

		inc	(iy+VAR_ROUND_NUMBER)

		GET_GAME_VARIABLE	VAR_COMBAT_MODE			; ???

		jr	z, loc_6588

		GET_IY_A_FROM_TABLE	54h, 43h

		ld	e, a
		ld	hl, GAME_VARIABLES + VAR_BASE_DAMAGE

		GET_GAME_VARIABLE	VAR_SPELL_ID			; ???

		jr	nz, loc_6582

		ld	(hl), e

loc_6582:
		cp	5
		jr	nz, loc_6588

		inc	hl
		ld	(hl), e

loc_6588:
		ld	b, 0FFh

		GET_GAME_VARIABLE	VAR_AMBUSH_FLAG			; ???

		jr	nz, loc_65F1

		GET_GAME_VARIABLE	VAR_ENCOUNTER_CTR			; ???

		ld	c, a
		jr	nz, loc_65A3

		GET_RND_BY_PARAM	3

		ld	e, a

		GET_GAME_VARIABLE	VAR_UNDERGROUND

		jr	nz, loc_65A0

		ld	e, 0

loc_65A0:
		ld	(iy+VAR_ENEMY_COUNT), e

loc_65A3:
		inc	b

		CALC_IN_FB7D

		dec	c
		inc	c
		jr	z, loc_65AF

		GET_B_FROM_TABLE	41h

		jr      nz, loc_65C0

loc_65AF:
		GET_IY_A_FROM_TABLE	54h, 4Fh

		ld	e, a

		GET_IY_A_FROM_TABLE	54h, 50h

		ld	d, a

		GET_RND_NUMBERS

		and	e
		add	a, d
		jr	nz, loc_65C0

		inc	a

loc_65C0:
		GET_B_FROM_LIST	41h

		CHECK_ITEM_MASK	71h, 7

		jr	z, loc_65CC

		GET_A_FROM_TABLE	64h

loc_65CC:
		dec	c
		inc	c
		jr	nz, loc_65DD

		and	(iy+VAR_RND_LO)
		inc	a

		cp	64h			; 100
		jr	c, loc_65DA

		ld	a, 63h ; 'c'

loc_65DA:
		GET_B_FROM_LIST	36h

loc_65DD:
		GET_B_FROM_TABLE	36h

		ld	e, a

loc_65E1:
		GET_B_FROM_TABLE	41h

		CALC_MONSTER_HP

		ld	(hl), a
		inc	hl
		dec	e
		jr	nz, loc_65E1

		ld	a, b

		cp	(iy+VAR_ENEMY_COUNT)
		jr	c, loc_65A3

loc_65F1:
		inc	b
		xor	a

		GET_B_FROM_LIST	41h

		GET_B_FROM_LIST	36h

		ld	a, b

		cp	4
		jr	c, loc_65F1

		ret
