loc_82D7:
		ld	d, a
		ld	e, 0
		ld	b, a
		sla	b

		GET_B_FROM_TABLE	23h

		jr	loc_82EB

loc_82E2:
		ld	d, a
		ld	e, 1
		ld	b, a
		sla	b

		GET_B_FROM_TABLE	24h

loc_82EB:
		ld	l, a
		exx
		inc	hl
		ld	a, (hl)
		exx
		ld	h, a
		ld	(GAME_VARIABLES + VAR_15), hl
		ld	(iy+VAR_26), d
		ld	(iy+VAR_10), 1

		ret
