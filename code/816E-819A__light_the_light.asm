; --- light_the_light ------------------------------------------
; @done
; Implements a light / illumination spell. Sets the visible distance
; (VAR_LIGHT_DIST) from the spell's range table, then rolls a
; duration for the light (VAR_LIGHT) and, when the spell grants it,
; for secret-revealing (VAR_REVEAL_SECRET); a $FF table entry means
; unlimited duration. Shows the light icon and prints the trailing
; "..." (print_ellipsis).
; In:  spell parameters via the INX_* table indices; iy = game vars
light_the_light:
		GET_B_FROM_TABLE	INX_RANGE_VALUES

		ld	(GAME_VARIABLES + VAR_LIGHT_DIST),a

		GET_B_FROM_TABLE	INX_LIGHT_DURAT

		ld	d,a

		cp	$FF
		jr	z,infinite_light

		GET_RND_BY_PARAM	$0F

		add	a,d

infinite_light:
		ld	(GAME_VARIABLES + VAR_LIGHT),a

		GET_B_FROM_TABLE	INX_REVEAL_DURAT

		ld	e,a
		jr	z,no_reveal_secrets

		cp	$FF
		jr	z,infinite_reveal

		GET_RND_BY_PARAM	$0F

		inc	a
		add	a,e

infinite_reveal:
		ld	(GAME_VARIABLES + VAR_REVEAL_SECRET),a

no_reveal_secrets:
		SHOW_ICON	ICON_LIGHT

		jp	print_ellipsis
