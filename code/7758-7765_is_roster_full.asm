is_roster_full:
		ld	b, 1

loop_roster:
		FIND_HERO_BY_B

		jr	z, empty_hero_found

		inc	b
		ld	a, b
		sub	7
		jr	c, loop_roster

empty_hero_found:
		ccf

		ret
