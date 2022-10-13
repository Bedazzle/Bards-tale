clear_info_panl:
		push	bc

		RESET_ROW_COL

		ld	b, 0Ch				; 12 rows to go

clear_rows:
		PRINT_SPACE_LINE

		inc	(iy+VAR_CURSOR_ROW)
		djnz	clear_rows

		pop	bc

reset_row_col:
		ld	(iy+VAR_CURSOR_ROW), 3

reset_col:
		ld	(iy+VAR_CURSOR_COL), 15h

		ret
