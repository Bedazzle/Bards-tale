enter_hero_num:
		ENTER_1_TO_6

		ret	c

		push	bc

		FIND_HERO_BY_A

		pop	bc
		ret	z

		and	a

		ret
