enter_text:
		call	loc_623B
		ret	c

		PRINT_NEWLINE

		and	a

		ret
; -------------------------------------

loc_623B:
		push	de
		push	hl

		PRINT_NEWLINE

		ld	hl, GAME_VARIABLES + VAR_CURSOR_COL
		ld	(hl), 27h
		ld	a, '<'

		PRINT_WITH_CODES

		ld	(hl), 15h
		ld	a, ':'

		PRINT_WITH_CODES

		call	loc_6293
		ld	b, 0
		ld	de, TEXT_BUFFER

loc_6256:
		WAIT_KEY_DOWN

		cp	CODE_CR
		jr	z, loc_6289

		cp	CODE_ABORT
		jr	nz, loc_6264

		ld	b, 0
		jr	loc_6289
; -------------------------------------

loc_6264:
		cp	7Fh
		jr	nz, loc_627C

		ld	a, b
		or	a
		jr	z, loc_6256

		dec	b
		dec	de
		ld	a, 0FFh
		ld	(de), a
		dec	(hl)

		PRINT_SPACE

		PRINT_SPACE

		dec	b
		dec	de
		dec	(hl)
		dec	(hl)

		jr	loc_627F
; -------------------------------------

loc_627C:
		ld	(de), a

		PRINT_WITH_CODES

loc_627F:
		call	loc_6293
		inc	b
		inc	de
		ld	a, b
		cp	0Fh
		jr	c, loc_6256

loc_6289:
		pop	hl
		pop	de

		PRINT_SPACE

		ld	a, b
		or	a
		ccf
		ret	z
		and	a

		ret
; -------------------------------------

loc_6293:
		ld	a, '`'		; 60h

		PRINT_WITH_CODES

		dec	(hl)

		ret
