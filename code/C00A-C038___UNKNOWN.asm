loc_C00A:
		PUSH_REGS

		inc	(iy+VAR_PAUSE)		; pause ON
		dec	a
		ex	af, af'
		ld	a, 1
		ex	af, af'
		push	ix
		push	af
		ld	hl, addr_FBB8
		ld	b, 0Bh
		ld	a, 20h ; ' '

loc_C01E:
		ld	(hl), a
		dec	hl
		djnz	loc_C01E

		push	hl
		pop	ix
		pop	af
		push	hl
		call	loc_C03F
		pop	hl
		ld	b, 9

loc_C02D:
		ld	a, (hl)

		PRINT_WITH_CODES

		inc	hl

		djnz	loc_C02D

		pop	ix
		dec	(iy+VAR_PAUSE)		; pause OFF

		ret
