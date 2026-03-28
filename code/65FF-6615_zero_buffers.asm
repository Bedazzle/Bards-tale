zero_buffers:
		ld	hl, addr_FF77
		ld	bc, addr_9603

more_nullify:
		call	nullify_buffer
		dec	c
		jr	nz, more_nullify

		ld	(GAME_VARIABLES + VAR_SONG_MODIFIER), a
		ld	hl, GAME_VARIABLES + VAR_ANTIMAGIC
		ld	b, 9

		jp	nullify_buffer
