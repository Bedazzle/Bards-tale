sub_E54C:
		ENTER_1_TO_8

		ret	c

		inc	hl
		ld	a, (hl)
		or	a
		jr	nz, loc_E556

		scf

		ret

loc_E556:
		ld	e, a

		GET_A_FROM_TABLE	13h

		call	loc_77B0
		call	sub_E4F4
		and	a

		ret
