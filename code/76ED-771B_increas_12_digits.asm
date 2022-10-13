increas_12_digits:
		PUSH_REGS

		ld	a, e
		add	a, 0Bh

		GET_ATTR_BY_A

		ld	b, 0Ch
		ld	de, addr_FB5B

loop_inc_12_digi:
		ld	a, (de)
		add	a, (hl)
		ld	(hl), a
		dec	hl
		dec	de
		djnz	loop_inc_12_digi

convert_12_digits:
		ld	a, l
		add	a, 0Ch
		ld	l, a
		jr	nc, no_adr_hi_change

		inc	h

no_adr_hi_change:
		ld	b, 0Ch		; 12 digits
		ld	c, 0

loop_conv_12_digi:
		ld	a, c
		add	a, (hl)
		ld	(hl), a
		ld	c, 0

chk_dec_overflow:
		sub	0Ah			; decimal 10
		jr	c, no_overflow

		ld	(hl), a
		inc	c

		jr	chk_dec_overflow

no_overflow:
		dec	hl
		djnz	loop_conv_12_digi

		ret
