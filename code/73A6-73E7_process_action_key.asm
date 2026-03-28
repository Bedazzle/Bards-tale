loc_73A6:
		push	af

		WAIT_KEY_DOWN

		ld	a, (GAME_VARIABLES + VAR_KEEP_PRESSED)
		ld	(GAME_VARIABLES + VAR_PRESSED_KEY), a
		pop	af

loc_73B0:
		ld	e, a
		and	7Fh
		ld	b, a
		ld	d, c

		GET_GAME_VARIABLE	VAR_PRESSED_KEY

		jr	z, loc_73C8

		ld	l, a

		cp	CODE_ABORT
		ccf
		ret	z

loc_73BF:
		GET_C_FROM_TABLE	INX_ACTIONS_KEYS

		cp	l
		jr	z, loc_73CC

		inc	c
		djnz	loc_73BF

loc_73C8:
		or	1
		scf

		ret

loc_73CC:
		bit	7, e
		jr	z, loc_73D5

		ld	a, c
		sub	d
		ld	c, a
		and	a

		ret

loc_73D5:
		sla	c

		GET_C_FROM_TABLE	INX_ACTIONS_PROCS

		inc	c
		ld	l, a

		GET_C_FROM_TABLE	INX_ACTIONS_PROCS

		ld	h, a
		ld	(loc_73E3+1), hl

loc_73E3:
		call	0		; !!! SMC
		and	a

		ret
