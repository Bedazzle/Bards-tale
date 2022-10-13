choose_hero:
		ENTER_1_TO_6

		ret	c

		ld	(GAME_VARIABLES + VAR_ACTIVE_HERO), a

		FIND_HERO_BY_A

		ret	z

		CHECK_HERO_STATUS

		ccf
		ret	c

		ld	a, b

		PRINT_DIGIT

		ld	a, b
		and	a

		ret
