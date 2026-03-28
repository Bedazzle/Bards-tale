sub_E4F4:
		PUSH_REGS

		ld	hl, SOME_BUFF
		ld	b, 0Ch

loc_E4FB:
		srl	(hl)
		jr	nc, loc_E509

		dec	b
		jr	z, loc_E508

		inc	hl
		ld	a, (hl)
		add	a, 0Ah
		ld	(hl), a
		dec	hl

loc_E508:
		inc	b

loc_E509:
		inc	hl
		djnz	loc_E4FB

		ret
