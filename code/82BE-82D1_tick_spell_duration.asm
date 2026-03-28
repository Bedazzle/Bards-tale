sub_82BE:
		GET_GAME_VARIABLE	VAR_SPELL_ACTIVE		; ???

		ret     z

		ld      hl, (GAME_VARIABLES + VAR_SPELL_DURATION)
		ld      a, l
		or      h

		ret     z

		dec     hl
		ld      (GAME_VARIABLES + VAR_SPELL_DURATION), hl
		ld      a, l
		or      h

		ret     nz

		jp      sub_7A67
