; --- get_pressed_key --------------------------------------
; @done
; Poll the keyboard (ROM KEY_SCAN + repeat) and return a decoded
; key token. No key returns carry set and 0. Shifted keys pass
; through raw; the digits 0/5/8 are remapped to special token
; bytes ($7F, $C9, $C8), and any other unshifted key to $1B; the
; result is also stashed in VAR_KEEP_PRESSED.
; Out: a = key token, VAR_KEEP_PRESSED = same; carry set if no key
; Note: preserves bc/de/hl.
get_pressed_key:
		push	bc
		push	de
		push	hl
		call	ROM_KEY_SCAN
		ld	a,e
		inc	a
		jr	z,no_keypress

		call	ROM_KEY_REPEAT+2
		jr	nc,no_keypress

		bit	7,b
		jr	nz,set_pressed_key

		cp	'0'
		jr	z,pressed_key_0

		cp	'8'
		jr	z,pressed_key_8

		cp	'5'
		jr	nz,pressed_key_other

pressed_key_5:
		ld	a,$C9			; C9 = RET

		jr	set_pressed_key
; -------------------------------------

pressed_key_other:
		ld	a,$1B

		jr	set_pressed_key
; -------------------------------------

pressed_key_8:
		ld	a,$C8			; C8 = RET Z

		jr	set_pressed_key
; -------------------------------------

pressed_key_0:
		ld	a,$7F 			; 7F = LD A,A

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
		ld	(GAME_VARIABLES + VAR_KEEP_PRESSED),a
		ret
