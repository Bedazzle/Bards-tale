; --- shift_price_buffer ----------------------------------------------
; @done
; Halve the 12-digit decimal price/gold buffer (SOME_BUFF) in place:
; shift each digit right one bit; when a digit shifts out a 1, carry it
; into the next-lower digit as +10. Used to derive the half price shown
; for selling / identifying an item.
shift_price_buffer:
		PUSH_REGS

		ld	hl,SOME_BUFF
		ld	b,$0C

.digit_loop:
		srl	(hl)
		jr	nc,.next_digit

		dec	b
		jr	z,.last_digit

		inc	hl
		ld	a,(hl)
		add	a,$0A
		ld	(hl),a
		dec	hl

.last_digit:
		inc	b

.next_digit:
		inc	hl
		djnz	.digit_loop

		ret
