; --- interrupt --------------------------------------------
; @done
; The maskable-interrupt (frame) service routine. Saves the full
; register set, stirs the 16-bit RNG (VAR_RND_HI/LO) with the pending
; dynamic-proc address, polls the keyboard (get_pressed_key), ticks
; active spell durations when no event is in progress, and — while the
; game is not paused (VAR_PAUSE) — advances one game turn (day/night
; cycle) via process_game_turn, then restores everything and returns.
; Note: iy = GAME_VARIABLES; dynamic_funct+1 SMC slot is saved/restored
;       around the tick so a nested RST-10h dispatch survives.
interrupt:
		di
		push	af
		push	bc
		push	de
		push	hl
		push	ix
		push	iy
		exx
		push	de
		push	hl
		push	bc
		exx
		ex	af,af'
		push	af

		ld	hl,(dynamic_funct+1)
		push	hl
		ld	a,(GAME_VARIABLES + VAR_RND_HI)
		xor	(hl)
		ld	(GAME_VARIABLES + VAR_RND_HI),a
		ld	a,(GAME_VARIABLES + VAR_RND_LO)
		ex	de,hl
		xor	(hl)
		ld	(GAME_VARIABLES + VAR_RND_LO),a

		call	get_pressed_key

		GET_GAME_VARIABLE	VAR_EVENT_DEPTH		; ???

		call	z,tick_spell_duration

		xor	a

		cp	(iy+VAR_PAUSE)
		call	z,process_game_turn 	; including day/night cycle

		xor	a
		out	($FE),a
		pop	hl
		ld	(dynamic_funct+1),hl

		pop	af
		ex	af,af'
		exx
		pop	bc
		pop	hl
		pop	de
		exx
		pop	iy
		pop	ix
		pop	hl
		pop	de
		pop	bc
		pop	af
		ei

		reti
