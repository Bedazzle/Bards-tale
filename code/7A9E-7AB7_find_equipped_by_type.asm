loc_7A9E:
		FIND_ATTR_AND_ADDRESS	CHAR_LASTITEM_ID

		ld	b, 8

loc_7AA3:
		ld	d, (hl)
		dec	hl

		GET_D_FROM_TABLE	INX_ITEM_SPECATT

		and	0Fh

		cp	e
		jr	nz, loc_7AB3

		ld	a, 1

		cp	(hl)
		inc	hl
		ret	z

		dec	hl

loc_7AB3:
		dec	hl
		djnz	loc_7AA3

		scf

		ret
