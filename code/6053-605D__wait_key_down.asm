; --- wait_key_down ----------------------------------------
; @done
; Block until a fresh keypress. First spins until no key is held
; (release), then spins until a key is pressed, so a key still down
; from a previous action is not re-read. Returns the key token.
; Out: a = key token (from get_pressed_key)
wait_key_down:
		call	get_pressed_key
		jr	nc,wait_key_down

wait_key_up:
		call	get_pressed_key
		jr	c,wait_key_up

		ret
