loc_6D05:
		PUSH_REGS

		FIND_HERO_BY_B

		FIND_ATTR_AND_ADDRESS	CHAR_ITEM_1_ID

		ld	b, 8

loc_6D0E:
		ld	c, (hl)

		GET_C_FROM_TABLE	INX_ITEM_SPECATT

		and	0Fh

		cp	6
		jr	nz, loc_6D26

		dec	hl
		ld	a, (hl)
		and	0Fh

		cp	1
		inc	hl
		jr	nz, loc_6D26

		GET_C_FROM_TABLE	INX_ITEM_EFFECTS

		and	a

		ret

loc_6D26:
		inc	hl
		inc	hl
		djnz	loc_6D0E

		scf

		ret
