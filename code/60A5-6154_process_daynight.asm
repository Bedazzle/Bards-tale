process_daynight:
		ld	hl, GAME_VARIABLES + VAR_DAY_INNER
		dec	(hl)
		ret	nz

		ld	(hl), 0Ah		; 10
		dec	(iy+VAR_DAY_OUTER_CTR)
		jp	nz, loc_6125

		ld	hl, GAME_VARIABLES + VAR_DAY_OUTER
		dec	(hl)
		jr	z, loc_60BF

		ld	a, (hl)

		cp	0Fh				; 15
		jr	z, day_change_night
		jr	nz, loc_60D2

loc_60BF:
		ld	(hl), 1Fh		; 31

day_change_night:
		ld	hl, GAME_VARIABLES + VAR_DAY_PART
		ld	a, (hl)
		xor	1
		ld	(hl), a
		ex	af, af'

		GET_GAME_VARIABLE	VAR_UNDERGROUND

		jr	nz, loc_60D2

		ex	af, af'
		ld	(GAME_VARIABLES + VAR_COPY_DAYPART), a

loc_60D2:
		GET_ATTR_SAVE_IX	1Fh

		jr	z, loc_60E7

		inc	a
		jr	z, loc_60E7

		dec	(hl)
		jr	nz, loc_60E7

		SHOW_ICON	ICON_SPACE

		xor	a
		ld	(GAME_VARIABLES + VAR_LIGHT_DIST), a
		ld	(GAME_VARIABLES + VAR_REVEAL_SECRET), a

loc_60E7:
		GET_ATTR_SAVE_IX	20h

		jr	z, loc_60F5

		inc	a
		jr	z, loc_60F5

		dec	(hl)
		jr	nz, loc_60F5

		SHOW_ICON	0Ah

loc_60F5:
		GET_ATTR_SAVE_IX	28h

		jr	z, loc_60FB

		dec	(hl)

loc_60FB:
		GET_ATTR_SAVE_IX	21h

		jr	z, loc_6109

		inc	a
		jr	z, loc_6109

		dec	(hl)
		jr	nz, loc_6109

		SHOW_ICON	0Dh

loc_6109:
		GET_ATTR_SAVE_IX	22h

		jr	z, loc_6117

		inc	a
		jr	z, loc_6117

		dec	(hl)
		jr	nz, loc_6117

		SHOW_ICON	0Bh

loc_6117:
		GET_ATTR_SAVE_IX	23h

		jr	z, loc_6125

		inc	a
		jr	z, loc_6125

		dec	(hl)
		jr	nz, loc_6125

		SHOW_ICON	0Ch

loc_6125:
		ld	hl, GAME_VARIABLES + VAR_DAY_MID_CTR
		dec	(hl)
		jr	nz, loc_6147

		ld	(hl), 50h

		GET_GAME_VARIABLE	VAR_DAY_TIMER_CHK			; ???

		jr	nz, loc_6147
		call	loc_7DF9

		GET_GAME_VARIABLE	VAR_NIGHT_TIMER			; ???

		jr	nz, loc_6144

		GET_GAME_VARIABLE	VAR_UNDERGROUND

         jr      nz, loc_6147

		GET_GAME_VARIABLE	VAR_DAY_PART

		jr	nz, loc_6147

loc_6144:
		call	sub_7DB8

loc_6147:
		ld	hl, GAME_VARIABLES+VAR_DAY_INNER_CTR
		dec	(hl)
		ret	nz

		ld	(hl), 20h ; ' '

		GET_GAME_VARIABLE	VAR_DAY_TIMER_CHK			; ???

		call	z, process_poison

		ret
