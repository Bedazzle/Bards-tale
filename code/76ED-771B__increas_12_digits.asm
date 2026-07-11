; --- increas_12_digits --------------------------------------
; @done
; Adds the 12-digit BCD number held in the scratch buffer
; (LEVEL_STOP+$A, least-significant digit downward) into a hero
; attribute field selected by e, then re-normalises the result.
; Used to credit gold/experience to a hero.
; In:  e = attribute field offset, ix = hero record,
;      LEVEL_STOP+$A = 12-digit addend
increas_12_digits:
		PUSH_REGS

		ld	a,e
		add	a,$0B

		GET_ATTR_BY_A

		ld	b,$0C
		ld	de,LEVEL_STOP+$A

loop_inc_12_digi:
		ld	a,(de)
		add	a,(hl)
		ld	(hl),a
		dec	hl
		dec	de
		djnz	loop_inc_12_digi

; --- convert_12_digits --------------------------------------
; @done
; Normalises a 12-digit decimal field in place: carries any digit
; >= 10 up into the next digit so every digit ends in 0..9.
; In:  hl = high end of the 12-digit field
; Note: shared tail of several BCD add routines (CONVERT_12_DIGITS).
convert_12_digits:
		ld	a,l
		add	a,$0C
		ld	l,a
		jr	nc,no_adr_hi_change

		inc	h

no_adr_hi_change:
		ld	b,$0C		; 12 digits
		ld	c,0

loop_conv_12_digi:
		ld	a,c
		add	a,(hl)
		ld	(hl),a
		ld	c,0

chk_dec_overflow:
		sub	$0A			; decimal 10
		jr	c,no_overflow

		ld	(hl),a
		inc	c

		jr	chk_dec_overflow

no_overflow:
		dec	hl
		djnz	loop_conv_12_digi

		ret
