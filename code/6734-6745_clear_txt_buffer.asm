clear_txt_buffer:
		ld	(GAME_VARIABLES + VAR_41), ix
		ld	hl, TEXT_BUFFER + 11h		;0FB73h
		ld	b, 11h

loop_clear_txtbuf:
		dec	hl
		ld	(hl), 0FFh
		djnz	loop_clear_txtbuf

		push	hl
		pop	ix

		ret
