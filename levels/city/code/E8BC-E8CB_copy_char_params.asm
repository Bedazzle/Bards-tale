sub_E8BC:
		ld	b, 4

		FIND_ATTR_AND_ADDRESS	CHAR_PARAMS_HI

		ex	de, hl

		FIND_ATTR_AND_ADDRESS	CHAR_60

loc_E8C5:
		ld	a, (hl)
		ld	(de), a
		inc	hl
		inc	de
		djnz	loc_E8C5

		ret
