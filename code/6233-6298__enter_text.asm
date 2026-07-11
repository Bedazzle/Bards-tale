; --- enter_text -------------------------------------------
; @done
; Read a line of text from the player, then move to a new line.
; Delegates the editing to input_text_line; on abort (carry set) it
; returns immediately, otherwise it emits a newline and returns
; carry clear.
; Out: carry set = aborted; text in TEXT_BUFFER (see input_text_line)
enter_text:
		call	input_text_line
		ret	c

		PRINT_NEWLINE

		and	a

		ret
; -------------------------------------

; --- input_text_line --------------------------------------
; @done
; Inline text-entry editor. Draws the "<...:" prompt with a cursor,
; then reads keys into TEXT_BUFFER until Enter or abort: Enter/abort
; finish, DELETE ($7F) backspaces (redrawing spaces), and up to 15
; printable characters are echoed and stored. Blanks the cursor on
; exit.
; Out: b = length; carry set if empty/aborted, clear otherwise;
;      TEXT_BUFFER holds the entered characters
; Note: de walks TEXT_BUFFER; hl tracks the cursor-column variable.
input_text_line:
		push	de
		push	hl

		PRINT_NEWLINE

		ld	hl,GAME_VARIABLES + VAR_CURSOR_COL
		ld	(hl),$27
		ld	a,'<'

		PRINT_WITH_CODES

		ld	(hl),$15
		ld	a,':'

		PRINT_WITH_CODES

		call	.draw_cursor
		ld	b,0
		ld	de,TEXT_BUFFER

.next_key:
		WAIT_KEY_DOWN

		cp	CODE_CR
		jr	z,.finish

		cp	CODE_ABORT
		jr	nz,.check_delete

		ld	b,0
		jr	.finish
; -------------------------------------

.check_delete:
		cp	$7F
		jr	nz,.store_char

		ld	a,b
		or	a
		jr	z,.next_key

		dec	b
		dec	de
		ld	a,$FF
		ld	(de),a
		dec	(hl)

		PRINT_SPACE

		PRINT_SPACE

		dec	b
		dec	de
		dec	(hl)
		dec	(hl)

		jr	.after_char
; -------------------------------------

.store_char:
		ld	(de),a

		PRINT_WITH_CODES

.after_char:
		call	.draw_cursor
		inc	b
		inc	de
		ld	a,b
		cp	$0F
		jr	c,.next_key

.finish:
		pop	hl
		pop	de

		PRINT_SPACE

		ld	a,b
		or	a
		ccf
		ret	z
		and	a

		ret
; -------------------------------------

.draw_cursor:
		ld	a,'`'		; 60h

		PRINT_WITH_CODES

		dec	(hl)

		ret
