attack_and_result:
		GET_GAME_VARIABLE	VAR_50		; ???

		jr	z, loc_70B4

loc_70AF:
		push	af

		PRINT_MESSAGE	69h			; "and"

		pop	af

loc_70B4:
		add	a, 0A4h

		PRINT_WORD

		ld	a, (GAME_VARIABLES + VAR_53)

		ret
