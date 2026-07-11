; --- set_pause ------------------------------------------------
; @done
; Handles the <Pause> key during speed-controlled output: pauses via
; pause_speed (which blocks for a keypress), then rejoins change_speed
; at set_speed to reload the delay and continue.
; In:  iy = game variables
; Note: tail-jumps into change_speed's set_speed.
set_pause:
		call	pause_speed

		jr	set_speed

; --- pause_speed ----------------------------------------------
; @done
; Prints "<Pausing>", raises the VAR_PAUSE flag and blocks until the
; player presses a key. Outside of a combat round (VAR_ROUND_NUMBER
; zero) it skips the spacer line; during a round it prints one. Clears
; VAR_PAUSE again on exit.
; In:  iy = game variables
pause_speed:
		PRINT_MESSAGE	$85			; "<Pausing>"

		inc	(iy+VAR_PAUSE)		; pause ON

		WAIT_KEY_DOWN

		GET_GAME_VARIABLE	VAR_ROUND_NUMBER		; ???

		jr	z,.skip_space

		PRINT_SPACE_LINE

.skip_space:
		dec	(iy+VAR_PAUSE)		; pause OFF

		ret
