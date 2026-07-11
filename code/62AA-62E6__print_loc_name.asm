; --- print_loc_name ---------------------------------------
; @done
; Print the current location's name centred on its row. Builds the
; name into TEXT_BUFFER (print_and_pad_row), measures its length up to the
; terminator, computes a centring column, prints up to 13
; characters, then restores the saved cursor row and text pointer.
; In:  iy = game variables base
; Note: pauses scrolling (VAR_PAUSE) around the print.
print_loc_name:
		inc	(iy+VAR_PAUSE)		; pause ON
		ld	hl,(GAME_VARIABLES + VAR_CURSOR_ROW)
		push	hl
		call	print_and_pad_row
		ld	hl,TEXT_BUFFER
		push	hl
		xor	a

.measure:
		bit	7,(hl)
		jr	nz,.centre

		inc	hl
		inc	a

		cp	$0D
		jr	nz,.measure

.centre:
		srl	a
		sub	6
		neg
		add	a,1
		ld	(GAME_VARIABLES + VAR_CURSOR_COL),a
		ld	b,$0D
		pop	hl

.print_loop:
		ld	a,(hl)
		or	a
		jp	m,.done

		PRINT_WITH_CODES

		inc	hl
		djnz	.print_loop

.done:
		pop	hl
		ld	(GAME_VARIABLES + VAR_CURSOR_ROW),hl
		ld	ix,(GAME_VARIABLES + VAR_TEXT_BUF_PTR)
		dec	(iy+VAR_PAUSE)		; pause OFF

		ret
