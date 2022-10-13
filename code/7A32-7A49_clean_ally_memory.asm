clean_ally_memory:
		push	ix
		ld	ix, ENEMY

		CLEAN_HERO_MEMORY

		pop	ix
		xor	a
		ld	(___table_93), a
		ld	(___table_94), a
		ld	(___table_95), a
		ld	(GAME_VARIABLES + VAR_66), a

		ret
