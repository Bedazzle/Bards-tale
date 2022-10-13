get_pressed_key:
		push	bc
		push	de
		push	hl
		call	ROM_KEY_SCAN
		ld	a, e
		inc	a
		jr	z, no_keypress

		call	ROM_KEY_REPEAT+2
		jr	nc, no_keypress

		bit	7, b
		jr	nz, set_pressed_key

		cp	'0'
		jr	z, pressed_key_0

		cp	'8'
		jr	z, pressed_key_8

		cp	'5'
		jr	nz, pressed_key_other

pressed_key_5:
		ld	a, 0C9h			; C9 = RET

		jr	set_pressed_key
; -------------------------------------

pressed_key_other:
		ld	a, 1Bh

		jr	set_pressed_key
; -------------------------------------

pressed_key_8:
		ld	a, 0C8h			; C8 = RET Z

		jr	set_pressed_key
; -------------------------------------

pressed_key_0:
		ld	a, 7Fh 			; 7F = LD A,A

set_pressed_key:
		cp	a
		jr	keep_pressd_key
; -------------------------------------

no_keypress:
		xor	a
		scf

keep_pressd_key:
		pop	hl
		pop	de
		pop	bc
		ld	(GAME_VARIABLES + VAR_KEEP_PRESSED),	a
		ret
