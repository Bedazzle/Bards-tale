; --- add_to_bcd_number -----------------------------------------------
; @done
; Adds an 8-bit value into the 12-digit BCD number at SCRATCH_BUFFER+$B4 at a
; digit position derived from the value itself (via bcd_index_to_addr), then
; re-normalises the whole number.
; In:  a = value to add
; Note: falls through to convert_12_digits; positioning math
;       partially inferred.
add_to_bcd_number:
		PUSH_REGS

		call	bcd_index_to_addr
		add	a,(hl)
		ld	(hl),a
		ld	hl,SCRATCH_BUFFER+$B4

		jr	convert_12_digits

; --- bcd_index_to_addr -----------------------------------------------
; @done
; Positions hl at a digit of the SCRATCH_BUFFER+$B4 BCD buffer, the digit
; index being derived from a (low 3 bits and a/8).
; In:  a = value/selector
; Out: hl -> chosen digit in SCRATCH_BUFFER+$B4, a = a/8
; Note: digit-indexing math partially inferred.
bcd_index_to_addr:
		push	af
		and	7
		ld	b,a
		ld	a,$0B
		sub	b
		ld	b,a
		pop	af
		call	divide_A_by_8
		ld	hl,SCRATCH_BUFFER+$B4
		inc	b

.advance:
		inc	hl
		djnz	.advance

		ret
