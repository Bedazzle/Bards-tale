clean_hero_memory:
		PUSH_REGS

		push	ix
		pop	hl
		ld	(hl), 0			; kill hero
		inc	hl
		ld	(hl), 20h ; ' '
		ld	d, h
		ld	e, l
		inc	de
		ld	bc, CHAR_NAME_TERM
		ldir				; clean name

		ld	(hl), 0
		ld	c, 53h 			; 83 = 100 (total bytes) - 15 (name) - 1 (name terminator) - 1 (pos in party)
		ldir				; clean hero attributes

		ld	(ix+CHAR_NAME_TERM), 0FFh

		ret
