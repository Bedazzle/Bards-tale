print_hero_attrib:
		PUSH_REGS

		PRINT_MESSAGE	2Ch			; "St:   IQ:   Dx:"
									; "Cn:	 Lk:"

		dec	(iy+VAR_CURSOR_ROW)
		ld	hl, addr_FB5C
		ld	bc, ATTR_COL
		push	bc
		call	print_attr_pair		; St
		call	print_attr_pair		; IQ
		call	print_attr_pair		; Dx

		PRINT_NEWLINE

		pop	bc
		call	print_attr_pair		; Cn

print_attr_pair:					; Lk
		ld	a, (bc)
		ld	(GAME_VARIABLES + VAR_CURSOR_COL), a
		ld	e, (hl)

		PRINT_NUM_FROM_E

		inc	hl
		inc	de
		inc	bc

		ret

ATTR_COL:
		db 18h		; 24
		db 1Eh		; 30
		db 24h		; 36
