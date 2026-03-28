loc_819B:
		GET_GAME_VARIABLE	VAR_53			; ???

		ld	a, (ENEMY+ENEMY_16)
		jr	c, loc_81A7

		jr	z, loc_81AC

		scf

		ret

loc_81A7:
		and	7Fh

		GET_A_FROM_TABLE	41h

loc_81AC:
		ld	de, 0Bh
		push	af
		ld	a, c

		cp	45h ; 'E'
		jr	nc, loc_81B8

		ld	de, 0

loc_81B8:
		pop	af
		ld	hl, addr_92CC
		add	hl, de
		ld	bc, 0Bh
		cpir
		jr	z, loc_81C6

		scf

		ret

loc_81C6:
		ld	a, (GAME_VARIABLES + VAR_4B)

		cp	43h ; 'C'
		jp	z, loc_8328

		cp	4Bh ; 'K'
		jr	nz, loc_8207

		jp	loc_8328
