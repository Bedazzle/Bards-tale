; https://chuntey.wordpress.com/2013/02/28/how-to-write-zx-spectrum-games-chapter-3/
; hl=pitch
; de=duration
call_beeper:
		ld	a, (loc_5C48)
		push	af
		xor	a
		ld	(loc_5C48), a		; NOP
		call	ROM_BEEPER
		pop	af
		ld	(loc_5C48), a		; INC IX

		ret
