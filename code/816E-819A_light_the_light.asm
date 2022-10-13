light_the_light:
		GET_B_FROM_TABLE	INX_RANGE_VALUES

		ld	(GAME_VARIABLES + VAR_LIGHT_DIST), a

		GET_B_FROM_TABLE	INX_LIGHT_DURAT

		ld	d, a

		cp	0FFh
		jr	z, infinite_light

		GET_RND_BY_PARAM	0Fh

		add	a, d

infinite_light:
		ld	(GAME_VARIABLES + VAR_LIGHT), a

		GET_B_FROM_TABLE	INX_REVEAL_DURAT

		ld	e, a
		jr	z, no_reveal_secrets

		cp	0FFh
		jr	z, infinite_reveal

		GET_RND_BY_PARAM	0Fh

		inc	a
		add	a, e

infinite_reveal:
		ld	(GAME_VARIABLES + VAR_REVEAL_SECRET), a

no_reveal_secrets:
		SHOW_ICON	ICON_LIGHT

		jp	print_ellipsis
