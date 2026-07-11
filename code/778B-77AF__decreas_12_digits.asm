; --- decreas_12_digits --------------------------------------
; @done
; Subtracts a 12-digit BCD number from a hero attribute field,
; borrowing across digits so each stays in 0..9. Used to debit
; gold/experience.
; In:  LEVEL_STOP+$A = amount to subtract; get_attr_by_E selects the field (hl)
decreas_12_digits:
		PUSH_REGS

		call	get_attr_by_E
		ld	de,LEVEL_STOP+$A

dec_digits_at_hl:
		ld	b,$0C

.digit_loop:
		ld	a,(hl)
		ex	de,hl
		sub	(hl)
		ex	de,hl
		ld	(hl),a
		jr	nc,.next_digit

		push	hl
		ld	c,b

.borrow_loop:
		ld	a,(hl)
		add	a,$0A
		ld	(hl),a
		dec	hl
		dec	c
		jr	z,.borrow_done

		dec	(hl)

		jp	m,.borrow_loop

.borrow_done:
		pop	hl

.next_digit:
		dec	hl
		dec	de
		djnz	.digit_loop

		ret
