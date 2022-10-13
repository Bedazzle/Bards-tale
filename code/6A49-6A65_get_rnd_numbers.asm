get_rnd_numbers:
		ld	a, r
		xor	(iy+VAR_RND_LO)

		call	xor_by_hl

		ld	(GAME_VARIABLES + VAR_RND_LO), a
		xor	(iy+VAR_RND_HI)
		ex	de, hl
		xor	(hl)
		ex	de, hl

		call	xor_by_hl

		ld	(GAME_VARIABLES + VAR_RND_HI), a

		ret

xor_by_hl:
		xor	(hl)
		exx
		xor	(hl)
		exx

		ret
