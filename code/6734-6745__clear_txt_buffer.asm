; --- clear_txt_buffer -----------------------------------------
; @done
; Reset the on-screen text buffer: stores IX as the current text pointer
; (VAR_TEXT_BUF_PTR), fills the 17-byte buffer (TEXT_BUFFER..+$10) with
; $FF, and returns IX pointing at its start.
; Out: ix = start of text buffer
clear_txt_buffer:
		ld	(GAME_VARIABLES + VAR_TEXT_BUF_PTR),ix
		ld	hl,TEXT_BUFFER + $11		;0FB73h
		ld	b,$11

loop_clear_txtbuf:
		dec	hl
		ld	(hl),$FF
		djnz	loop_clear_txtbuf

		push	hl
		pop	ix

		ret
