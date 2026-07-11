; https://chuntey.wordpress.com/2013/02/28/how-to-write-zx-spectrum-games-chapter-3/
; --- call_beeper ------------------------------------------
; @done
; Emit a beep through the ROM BEEPER routine. Temporarily patches the
; self-modified byte at bin2dec_store_digit to $00 (NOP) so the tone loop runs
; cleanly, calls ROM_BEEPER, then restores the original opcode (an
; INC IX used at that slot elsewhere).
; In:  hl = pitch (tone period), de = duration.
; Note: writes the bin2dec_store_digit SMC slot.
call_beeper:
		ld	a,(bin2dec_store_digit)
		push	af
		xor	a
		ld	(bin2dec_store_digit),a		; NOP
		call	ROM_BEEPER
		pop	af
		ld	(bin2dec_store_digit),a		; INC IX

		ret
