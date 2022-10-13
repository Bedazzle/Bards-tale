find_hero_by_name:
		ld	hl, TEXT_BUFFER
		ld	c, b
		ld	b, 0
		add	hl, bc					; HL = end of name
		ld	a, c

loop_clr_txtbuf:
		ld	(hl), 20h 				; ' '
		inc	hl
		inc	a

		cp	10h						; hero name length = 15
		jr	c, loop_clr_txtbuf

		ld	(hl), 0FFh
		ld	b, 6

loop_for_heroes:
		FIND_HERO_BY_B

		ld	hl, TEXT_BUFFER
		ld	c, 0Fh					; hero name length = 15

name_check:
		ld	a, (ix+CHAR_NAME)

		cp	(hl)
		jr	nz, mismatch_hero

		inc	hl
		inc	ix
		dec	c
		jr	nz, name_check

		jp	find_hero_by_B

mismatch_hero:
		dec	b
		jp	p, loop_for_heroes

		and	a

		ret
