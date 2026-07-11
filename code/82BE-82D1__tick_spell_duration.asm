; --- tick_spell_duration --------------------------------------
; @done
; Per-round upkeep for the party's currently active spell/song
; effect. If a spell/song is active (VAR_SPELL_ACTIVE) and its
; remaining-duration counter (VAR_SPELL_DURATION) is non-zero,
; decrement it; when it reaches zero the effect has expired and
; control passes to process_special_event to remove it. Called each
; combat round from the interrupt handler.
; In:  iy = game variables base
; Out: VAR_SPELL_DURATION decremented; jumps to process_special_event
;      on expiry
; Note: returns immediately if no spell is active or the timer is
;       already zero.
tick_spell_duration:
		GET_GAME_VARIABLE	VAR_SPELL_ACTIVE		; ???

		ret     z

		ld      hl,(GAME_VARIABLES + VAR_SPELL_DURATION)
		ld      a,l
		or      h

		ret     z

		dec     hl
		ld      (GAME_VARIABLES + VAR_SPELL_DURATION),hl
		ld      a,l
		or      h

		ret     nz

		jp      process_special_event
