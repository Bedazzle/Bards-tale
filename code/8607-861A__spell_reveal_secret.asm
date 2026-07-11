; --- spell_reveal_secret ------------------------------------
; @done
; Revelation-type spell handler. If the party is underground and
; the map cell at CITY_MAP_DATA+$026A holds a hidden feature (zero
; flag byte), clear its secret-state marker and set VAR_REVEAL_FLAG
; so the feature is drawn. Always finishes by printing "...".
; In:  iy = game variables
; Note: no-op above ground or when nothing is hidden here.
spell_reveal_secret:
		GET_GAME_VARIABLE	VAR_UNDERGROUND

		jr	z,.done

		ld	a,(CITY_MAP_DATA+$026A)
		or	a
		jr	nz,.done

		ld	(SPELL_SECRET_STATE),a
		inc	(iy+VAR_REVEAL_FLAG)

.done:
		jp	print_ellipsis
