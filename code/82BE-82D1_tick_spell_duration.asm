sub_82BE:
		GET_GAME_VARIABLE	VAR_10		; ???

		ret     z

		ld      hl, (GAME_VARIABLES + VAR_15)
		ld      a, l
		or      h

		ret     z

		dec     hl
		ld      (GAME_VARIABLES + VAR_15), hl
		ld      a, l
		or      h

		ret     nz

		jp      sub_7A67
