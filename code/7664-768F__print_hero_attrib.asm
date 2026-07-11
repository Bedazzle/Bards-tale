; --- print_hero_attrib --------------------------------------
; @done
; Prints a hero's five primary attributes (St, IQ, Dx, Cn, Lk) into
; the info panel from the unpacked-attribute buffer at GUARDIAN_TYPE,
; placing each number at its screen column from ATTR_COL.
; In:  GUARDIAN_TYPE = unpacked attributes (see unpack_hero_attrs)
print_hero_attrib:
		PUSH_REGS

		PRINT_MESSAGE	$2C			; "St:   IQ:   Dx:"
									; "Cn:	 Lk:"

		dec	(iy+VAR_CURSOR_ROW)
		ld	hl,GUARDIAN_TYPE
		ld	bc,ATTR_COL
		push	bc
		call	print_attr_pair		; St
		call	print_attr_pair		; IQ
		call	print_attr_pair		; Dx

		PRINT_NEWLINE

		pop	bc
		call	print_attr_pair		; Cn

; --- print_attr_pair ----------------------------------------
; @done
; Prints one attribute number: sets the cursor column from (bc),
; reads the value from (hl), prints it, then advances hl/de/bc to
; the next attribute. Called four times and then fallen into once,
; so five values are printed in all.
; In:  hl = attribute source, bc = column table, de = scratch
; Out: hl/de/bc advanced by one
print_attr_pair:					; Lk
		ld	a,(bc)
		ld	(GAME_VARIABLES + VAR_CURSOR_COL),a
		ld	e,(hl)

		PRINT_NUM_FROM_E

		inc	hl
		inc	de
		inc	bc

		ret

; --- ATTR_COL -----------------------------------------------
; @done
; Screen columns for the 2nd..4th attribute numbers on a line
; (24, 30, 36).
ATTR_COL:
		DB $18		; 24
		DB $1E		; 30
		DB $24		; 36
