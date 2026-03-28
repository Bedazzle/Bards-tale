dyn_proc_89:				; PRINT_ACTOR_NAME
		PUSH_REGS

		GET_GAME_VARIABLE	VAR_TARGET_ID		; ???

		ld	b, a
		jr	c, loc_71A8

		FIND_HERO_BY_B

		jp	print_IX_heroname

loc_71A8:
		PRINT_MESSAGE	10h		; "A"

		res	7, b

		jp	loc_70A0
