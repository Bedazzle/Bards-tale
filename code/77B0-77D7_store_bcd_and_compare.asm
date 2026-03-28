loc_77B0:
		PUSH_REGS

		push	af

		NULLIFY_FB5B

		pop	af
		call	sub_7728
		dec	hl

loc_77BA:
		cp	0Ah
		jr	c, loc_77C3

		inc	(hl)
		sub	0Ah

		jr	loc_77BA

loc_77C3:
		inc	hl
		ld	(hl), a

check_12_digits:
		PUSH_REGS

		ld	a, e

		GET_ATTR_BY_A

		ex	de, hl
		ld	hl, SOME_BUFF
		ld	b, 0Ch

loc_77D0:
		ld	a, (de)

		cp	(hl)
		ret	nz

		inc	hl
		inc	de
		djnz	loc_77D0

		ret
