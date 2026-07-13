; --- zero_buffers ---------------------------------------------
; @done
; Clear the combat working buffers. Nullifies a run of buffers starting
; at FF77 (via nullify_buffer), then zeroes VAR_SONG_MODIFIER and the
; 9-byte anti-magic block at VAR_ANTIMAGIC.
; In:  iy = game variables base
zero_buffers:
		ld	hl,HERO_CAST_STATE+$2
		ld	bc,$9603		; b=$96 bytes/block, c=3 blocks

more_nullify:
		call	nullify_buffer
		dec	c
		jr	nz,more_nullify

		ld	(GAME_VARIABLES + VAR_SONG_MODIFIER),a
		ld	hl,GAME_VARIABLES + VAR_ANTIMAGIC
		ld	b,9

		jp	nullify_buffer
