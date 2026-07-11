; --- print_plus_minus ---------------------------------------
; @done
; Draw the signed delta used by adjust_value_updown: a '+' or '-'
; sign at cursor column 28 followed by the magnitude. A stored
; value >= 22 is treated as negative and negated for display.
; In:  c = signed delta, iy = game variables
; Note: only touches the text buffer; caller supplies register state.
print_plus_minus:
		PUSH_REGS

		ld	(iy+VAR_CURSOR_COL),$1C	; 28
		bit	7,c
		ld	a,'+'
		jr	z,print_sign

		ld	a,'-'

print_sign:
		PRINT_WITH_CODES

		ld	a,c

		cp	$16
		jr	c,print_as_is

		neg

print_as_is:
		ld	e,a

		jp	print_num_from_E
