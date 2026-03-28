clean_ally_memory:
		push	ix
		ld	ix, ENEMY

		CLEAN_HERO_MEMORY

		pop	ix
		xor	a
		ld	(___table_93), a
		ld	(___table_94), a
		ld	(ALLY_DATA), a
		ld	(GAME_VARIABLES + VAR_ALLY_COUNTER), a

		ret
