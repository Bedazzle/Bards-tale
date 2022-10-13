game_cycle:
		ZERO_BUFFERS

		RST_10_4A

		call	sub_C192
		ld	(iy+VAR_40), 0

loop_city_walk:
		halt

		GET_GAME_VARIABLE	VAR_KEEP_PRESSED

		jr	nz, press_hero_number

		ld	(GAME_VARIABLES + VAR_PRESSED_KEY), a

		GET_RND_BY_PARAM	3Fh

		jr	nz, no_city_ambush

		GET_RND_BY_PARAM	3Fh

		IFDEF NOCITYMONSTERS
			jr	no_city_ambush
		ELSE
			jr	nz, no_city_ambush
		ENDIF

city_ambush:
		ld	(GAME_VARIABLES + VAR_5A), a
		call	combat_foes

		RST_10_4B

		jr	loop_city_walk

; -------------------------------------

no_city_ambush:
		GET_RND_BY_PARAM 3Fh

		jr	nz, loop_city_walk

		GET_RND_BY_PARAM	7Fh

		jr	nz, loop_city_walk

		call	sub_C195
		jr	c, loop_city_walk

		RST_10_4B

		jr	loop_city_walk
