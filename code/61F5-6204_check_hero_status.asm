check_hero_status:
		ld	a, (ix+CHAR_STATUS)

		cp	STATUS_DEAD
		jr	c, is_alive_and_ok

		cp	STATUS_POSSESSED
		inc	a
		dec	a
		ccf

		ret

is_alive_and_ok:
		cp	a
		scf

		ret
