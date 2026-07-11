; --- print_number -----------------------------------------
; @done
; Render the 16-bit value in DE as a decimal number in the text
; output. Converts it to digit cells via binary_to_decimal, blanks leading
; zeros (shown as spaces), wraps to a new line if it would pass
; column 41, then emits the significant digits.
; In:  de = value to print
; Note: the SMC_print_with_codes slot (NOP/NOP here) is patched by
;       print_hero_attr to actually print the leading pad spaces;
;       pauses scrolling via VAR_PAUSE.
print_number:
		inc	(iy+VAR_PAUSE)		; pause ON
		push	hl
		push	de
		push	bc
		call	binary_to_decimal
		ld	b,4
		ld	c,7
		ld	hl,LEVEL_STOP+$6

print_some_spaces:
		ld	a,(hl)
		or	a
		jr	nz,no_spaces

		ld	a,$20 			; ' '

SMC_print_with_codes:
		nop					; !!! SMC
		nop					; !!! SMC

		inc	hl
		inc	c
		djnz	print_some_spaces

no_spaces:
		ld	a,$0D
		sub	c
		add	a,(iy+VAR_CURSOR_COL)

		cp	$29 			; dec 41
		jr	c,no_wrap

		PRINT_NEWLINE		; wrap text

no_wrap:
		inc	b

loop_print_digit:
		ld	a,(hl)

		PRINT_DIGIT

		inc	hl
		djnz	loop_print_digit

		dec	(iy+VAR_PAUSE)		; pause OFF
		pop	bc
		pop	de
		pop	hl

		ret
