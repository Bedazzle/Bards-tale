; --- nullify_FDDD -----------------------------------------
; @done
; Zero the 7-byte buffer ending at COMBAT_UI_TEXT+$6 (falls into
; nullify_buffer).
nullify_FDDD:
		ld	b,7
		ld	hl,COMBAT_UI_TEXT+$6

		jr	nullify_buffer

; --- nullify_FB5B -----------------------------------------
; @done
; Zero the 12-byte digit buffer ending at LEVEL_STOP+$A (falls into
; nullify_buffer).
nullify_FB5B:
		ld	hl,LEVEL_STOP+$A
		ld	b,$0C

; --- nullify_buffer ---------------------------------------
; @done
; Clear a block of RAM downward: write 0 to (hl) and decrement hl,
; B times.
; In:  hl = last byte of block, b = byte count
; Out: block zeroed, hl = one below block, a = 0
nullify_buffer:
		xor	a

loop_nullify:
		ld	(hl),a
		dec	hl
		djnz	loop_nullify

		ret
