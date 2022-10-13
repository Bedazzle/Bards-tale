find_hero_by_A:
		ld	b, a

find_hero_by_B:
		ld	a, b		; in: B	= hero number
						; out: IX = start of hero block
		cp	7
		jr	c, find_hero_data

		ld	b, 1

find_hero_data:
		push	bc
		push	de
		ld	de, 65h
		ld	ix, HEROES
		inc	b

loop_find_hero:
		add	ix, de
		djnz	loop_find_hero

		pop	de
		pop	bc

		GET_ATTR_BY_PARAM_SAVE_HL	CHAR_NAME

		scf

		ret
