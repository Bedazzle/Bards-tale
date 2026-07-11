; --- process_game_turn ------------------------------------
; @done
; Advance one game turn (called from the interrupt handler). Saves
; the volatile game-variable / sentence / scratch buffers into the
; param-copy area, runs the day/night update (process_daynight),
; redraws the party stat table if VAR_REDRAW_STATS is set, then
; restores the saved buffers.
; In:  iy = game variables base
; Note: VAR_TURN_PROCESSING is held set for the duration.
process_game_turn:
		inc	(iy+VAR_TURN_PROCESSING)				; ??? processing day/night cycle flag

param_to_copy:
		ld	hl,GAME_VARIABLES + VAR_TREASURE_LO
		ld	bc,$33					; 51
		ld	de,GAME_PARAM_COPY
		ldir

		ld	hl,sentence			; to sentence_2
		ld	c,$14					; 20
		ldir

		ld	hl,SOME_BUFF			; to some_buff_copy
		ld	c,$0C					; 12
		ldir

		call	process_daynight
		dec	(iy+VAR_TURN_PROCESSING)				; ??? processing day/night cycle flag

		GET_GAME_VARIABLE	VAR_REDRAW_STATS		; ???

		jr	z,copy_to_param

		ld	(iy+VAR_REDRAW_STATS),0

		PRINT_STATS_TABLE

copy_to_param:
		ld	de,GAME_VARIABLES + VAR_TREASURE_LO
		ld	hl,GAME_PARAM_COPY
		ld	bc,$33
		ldir

		ld	de,sentence
		ld	c,$14
		ldir

		ld	de,SOME_BUFF
		ld	c,$0C
		ldir

		ret
