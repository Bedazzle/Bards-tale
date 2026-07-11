; --- prnt_space_line --------------------------------------
; @done
; Print a 20-character blank line across the info panel (from the
; reset column), then reset the cursor column via reset_col.
; In:  iy = game variables base
; Note: preserves bc/de/hl.
prnt_space_line:
		push	bc
		push	hl
		push	de

		RESET_COL

		ld	b,$14		; 20 dec

print_spaces:
		ld	a,$20 ; ' '
		push	bc
		call	print_A_symbol
		pop	bc
		inc	(iy+VAR_CURSOR_COL)
		djnz	print_spaces

		pop	de
		pop	hl
		pop	bc

		jr	reset_col
