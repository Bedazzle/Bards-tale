print_number:
		inc	(iy+VAR_PAUSE)		; pause ON
		push	hl
		push	de
		push	bc
		call	loc_5C17
		ld	b, 4
		ld	c, 7
		ld	hl, addr_FB57

print_some_spaces:
		ld	a, (hl)
		or	a
		jr	nz, no_spaces

		ld	a, 20h 			; ' '

SMC_print_with_codes:
		nop					; !!! SMC
		nop					; !!! SMC

		inc	hl
		inc	c
		djnz	print_some_spaces

no_spaces:
		ld	a, 0Dh
		sub	c
		add	a, (iy+VAR_CURSOR_COL)

		cp	29h 			; dec 41
		jr	c, no_wrap

		PRINT_NEWLINE		; wrap text

no_wrap:
		inc	b

loop_print_digit:
		ld	a, (hl)

		PRINT_DIGIT

		inc	hl
		djnz	loop_print_digit

		dec	(iy+VAR_PAUSE)		; pause OFF
		pop	bc
		pop	de
		pop	hl

		ret
