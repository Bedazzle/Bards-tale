print_yesno_wait:
		PRINT_MESSAGE	46h			; "(Y-N)"

yesno_wait:
		WAIT_KEY_DOWN

		ld	(GAME_VARIABLES + VAR_PRESSED_KEY), a
		cp	'Y'
		ccf
		ret	z

		cp	'N'
		ret	z

		jr	yesno_wait
