sub_E50D:
		CLEAR_INFO_PANEL

		GET_ATTR_BY_PARAM	CHAR_INVENTORY

		ld	b, 31h ; '1'

loc_E514:
		ld	d, (hl)
		inc	hl
		ld	a, (hl)
		or	a
		jr	z, loc_E544

		ld	e, a
		ld	a, b

		PRINT_WITH_CODES

		ld	a, '.'

		PRINT_WITH_CODES

		ld	a, d
		or	a
		ld	a, e
		jp	p, loc_E52F

		GET_E_FROM_TABLE	INX_ITEM_SPECATT

		and	0Fh
		or	80h

loc_E52F:
		call	loc_C00A
		ld	(iy+VAR_CURSOR_COL), 21h

		GET_E_FROM_TABLE	13h

		call	loc_77B0
		call	sub_E4F4
		call	loc_88E5

		PRINT_NEWLINE

loc_E544:
		inc	b
		ld	a, b
		inc	hl

		cp	39h ; '9'
		jr	c, loc_E514

		ret
