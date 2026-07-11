; --- process_special_event -----------------------------------
; @done
; Runs the queued "special" spell event, if any. Does nothing when
; VAR_SPELL_ACTIVE is clear; otherwise it increments VAR_EVENT_DEPTH
; as a re-entrancy guard around run_spell_event and restores it after.
; In:  iy = game variables base
process_special_event:
		GET_GAME_VARIABLE	VAR_SPELL_ACTIVE			; ???

		ret	z

		inc	(iy+VAR_EVENT_DEPTH)
		call	run_spell_event
		dec	(iy+VAR_EVENT_DEPTH)

		ret

; --- run_spell_event -----------------------------------------
; @done
; Carries out the queued spell event. Clears combat mode, then
; branches on VAR_SPELL_ID: id 1 extinguishes the party light
; (zeroes VAR_LIGHT / VAR_LIGHT_DIST and shows the "dark" icon 9);
; id 4 hands off to the effect/movement handler at set_song_effect (first
; clearing a param-copy byte unless a turn is being processed); any
; other id does nothing.
; In:  iy = game variables base
run_spell_event:
		call	clear_spell_active
		xor	a
		ld	(GAME_VARIABLES + VAR_COMBAT_MODE),a
		ld	a,(GAME_VARIABLES + VAR_SPELL_ID)

		cp	4
		jr	z,.spell4

		sub	1
		ret	nz

		ld	(GAME_VARIABLES + VAR_LIGHT),a
		ld	(GAME_VARIABLES + VAR_LIGHT_DIST),a

		SHOW_ICON	9

		ret

.spell4:
		GET_GAME_VARIABLE	VAR_TURN_PROCESSING			; ???

		jr	z,.dispatch

		xor	a
		ld	(GAME_PARAM_COPY+$12),a

.dispatch:
		ld	b,0

		jp	set_song_effect
