print_hero_attr:
		push	hl
		inc	(iy+VAR_PAUSE)		; pause ON

		GET_ATTR_BY_A

		ld	e, a
		dec	hl
		ld	d, (hl)
		ld	hl, 1ED7h		; RST 10 / $1E (prnt_with_codes)
		ld	(SMC_print_with_codes), hl
		call	print_number
		ld	hl, 0			; NOP / NOP
		ld	(SMC_print_with_codes), hl
		pop	hl
		dec	(iy+VAR_PAUSE)		; pause OFF

		ret
