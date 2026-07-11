; --- print_large_number -------------------------------------
; @done
; Print a 12-digit number held in table $5E, suppressing leading
; zeros. Before printing it counts the significant digits and, if
; they would run past screen column 41, emits a newline first so
; the number is not split across the line edge.
; In:  iy = game variables
print_large_number:
		push	bc
		ld	b,0

.skip_zeros:
		GET_B_FROM_TABLE	$5E

		or	a
		jr	nz,.check_wrap

		inc	b
		ld	a,b

		cp	$0B			; scanned first 11 digits?
		jr	c,.skip_zeros

.check_wrap:
		ld	a,$0B
		sub	b			; a = number of digits still to print
		add	a,(iy+VAR_CURSOR_COL)		; CURSOR_COL

		cp	$29 			; would end past column 41?
		jr	c,.print_digit

		PRINT_NEWLINE

.print_digit:
		GET_B_FROM_TABLE	$5E

		PRINT_DIGIT

		inc	b
		ld	a,b

		cp	$0C			; all 12 digits done?
		jr	c,.print_digit

		pop	bc

		ret
