wait_key_down:
		call	get_pressed_key
		jr	nc, wait_key_down

wait_key_up:
		call	get_pressed_key
		jr	c, wait_key_up

		ret
