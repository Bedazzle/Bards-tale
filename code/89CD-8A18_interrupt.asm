interrupt:
		di
		push	af
		push	bc
		push	de
		push	hl
		push	ix
		push	iy
		exx
		push	de
		push	hl
		push	bc
		exx
		ex	af, af'
		push	af

		ld	hl, (dynamic_funct+1)
		push	hl
		ld	a, (GAME_VARIABLES + VAR_RND_HI)
		xor	(hl)
		ld	(GAME_VARIABLES + VAR_RND_HI), a
		ld	a, (GAME_VARIABLES + VAR_RND_LO)
		ex	de, hl
		xor	(hl)
		ld	(GAME_VARIABLES + VAR_RND_LO), a

		call	get_pressed_key

		GET_GAME_VARIABLE	VAR_0F		; ???

		call	z, sub_82BE

		xor	a

		cp	(iy+VAR_PAUSE)
		call	z, process_game_turn 	; including day/night cycle

		xor	a
		out	(0FEh),	a
		pop	hl
		ld	(dynamic_funct+1), hl

		pop	af
		ex	af, af'
		exx
		pop	bc
		pop	hl
		pop	de
		exx
		pop	iy
		pop	ix
		pop	hl
		pop	de
		pop	bc
		pop	af
		ei

		reti
