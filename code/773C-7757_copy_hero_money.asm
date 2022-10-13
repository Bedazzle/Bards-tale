copy_hero_money:
		PUSH_REGS

		ld	hl, addr_FB5B

loc_7741:
		ld	b, CHAR_GOLD_END - CHAR_GOLD_START +1

loop_copy_money:
		ld	a, (ix+CHAR_GOLD_END)
		ld	(hl), a
		dec	hl
		dec	ix
		djnz	loop_copy_money

		ret

loc_774D:
		PUSH_REGS

		FIND_ATTR_AND_ADDRESS	CHAR_EXP_END

		ld	ix, addr_FB2C

		jr	loc_7741
