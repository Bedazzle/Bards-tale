; --- swap_byte_buffer -----------------------------------------
; @done
; Exchange A bytes between the buffers at HL and DE.
; In:  hl, de = buffer pointers, a = byte count
; Note: saves/restores registers via PUSH_REGS.
swap_byte_buffer:
		PUSH_REGS

		ld	b,a

loop_swap:
		ld	a,(de)
		ld	c,(hl)
		ld	(hl),a
		ld	a,c
		ld	(de),a
		inc	hl
		inc	de
		djnz	loop_swap

		ret
