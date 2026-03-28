sub_E8A8:
		PUSH_REGS

		ld	b, 4
		ld	de, ___table_3+3	;7DB7h

		FIND_ATTR_AND_ADDRESS	CHAR_13

loc_E8B2:
		ld	a, (de)

		cp	(hl)
		jr	nz, locret_E8BB

		dec	de
		dec	hl
		djnz	loc_E8B2

		xor	a

locret_E8BB:
		ret
