; --- print_yesno_wait -------------------------------------
; @done
; Prompt "(Y-N)" and wait for a Yes/No answer, ignoring other keys.
; Out: carry set = Yes, carry clear = No; VAR_PRESSED_KEY = the key
print_yesno_wait:
		PRINT_MESSAGE	$46			; "(Y-N)"

yesno_wait:
		WAIT_KEY_DOWN

		ld	(GAME_VARIABLES + VAR_PRESSED_KEY),a
		cp	'Y'
		ccf
		ret	z

		cp	'N'
		ret	z

		jr	yesno_wait
