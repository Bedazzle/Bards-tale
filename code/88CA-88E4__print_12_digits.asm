; --- print_12_digits ----------------------------------------
; @done
; Print a 12-digit (BCD) character attribute field with leading
; zeros suppressed as spaces. The field is selected by e via
; GET_ATTR_BY_A; once a non-zero digit is seen the remaining zeros
; print normally. If bit 7 of e is set on entry, no suppression is
; applied (all 12 digits printed).
; In:  e = attribute id (bit 7 set = force all digits), iy = game vars
print_12_digits:
		PUSH_REGS

		ld	a,e

		GET_ATTR_BY_A

		ld	b,$0C		; 12 digits

next_digit:
		ld	a,(hl)
		inc	hl
		or	a
		jr	nz,print_nonzero

		bit	7,e
		jr	nz,print_nonzero

		PRINT_SPACE

go_next_digit:
		djnz	next_digit

		ret

print_nonzero:
		PRINT_DIGIT

		ld	e,$FF

		jr	go_next_digit
