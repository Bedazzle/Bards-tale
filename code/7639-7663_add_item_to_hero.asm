loc_7639:
		PUSH_REGS

		FIND_HERO_BY_A

		ret	z

		FIND_ATTR_AND_ADDRESS	CHAR_ITEM_1_ID

		ld	b, 8
		xor	a

loop_hero_items:
		cp	(hl)
		jr	z, empty_item_slot

		inc	hl
		inc	hl
		djnz	loop_hero_items

		inc	a
		scf
		ret

empty_item_slot:
		ld	a, (ix+CHAR_CLASS)

		GET_A_FROM_TABLE	46h

		ld	c, a

		GET_E_FROM_TABLE	INX_ITEM_EQUIP

		and	c
		ld	a, 2
		jr	z, loc_765E

		xor	a

loc_765E:
		or	d
		ld	(hl), e
		dec	hl
		ld	(hl), a
		inc	a

		ret
