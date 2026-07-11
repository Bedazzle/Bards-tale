; --- clear_info_panl --------------------------------------
; @done
; Blank the 12-row info panel by printing a full space line on each
; row, then fall into reset_row_col to home the text cursor.
; In:  iy = game variables base
; Note: preserves bc.
clear_info_panl:
		push	bc

		RESET_ROW_COL

		ld	b,$0C				; 12 rows to go

clear_rows:
		PRINT_SPACE_LINE

		inc	(iy+VAR_CURSOR_ROW)
		djnz	clear_rows

		pop	bc

; --- reset_row_col ----------------------------------------
; @done
; Home the info-panel text cursor: row = 3, then set the column
; (falls into reset_col).
reset_row_col:
		ld	(iy+VAR_CURSOR_ROW),3

; --- reset_col --------------------------------------------
; @done
; Reset the text cursor column to $15 (the info-panel left edge).
reset_col:
		ld	(iy+VAR_CURSOR_COL),$15

		ret
