loc_5C17:
		inc	(iy+VAR_PAUSE)		; pause ON

		PUSH_REGS

		NULLIFY_FB5B

		ld	ix, addr_FB57
		ld	b, 5
		ld	hl, addr_9815

loc_5C27:
		ld	(iy+VAR_6C), 0
		push	bc

loc_5C2C:
		ld	b, (hl)
		dec	hl
		ld	c, (hl)
		inc	hl
		ex	de, hl
		push	hl
		and	a
		sbc	hl, bc
		ex	de, hl
		pop	bc
		jr	c, loc_5C3E

		inc	(iy+VAR_6C)

		jr	loc_5C2C

loc_5C3E:
		ld	d, b
		ld	e, c
		dec	hl
		dec	hl
		ld	a, (iy+VAR_6C)
		ld	(ix+CHAR_NAME),	a

loc_5C48:
		inc	ix				; !!! SMC
		pop	bc
		djnz	loc_5C27

		dec	(iy+VAR_PAUSE)		; pause OFF

		ret
