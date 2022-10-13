print_hero_items:
		CLEAR_INFO_PANEL

		PRINT_IX_HERO_NAME

		PRINT_NEWLINE

		ld	b, 0

loop_item_list:
		ld	a, b

		PRINT_NEXT_DIGIT	; item position in list

		ld	a, ')'

		PRINT_WITH_CODES

		ld	a, b
		add	a, a			; two byte per item, x2
		add	a, 50h 			; items start from index 50h in hero table

		GET_ATTR_BY_A

		ld	d, a
		ld	e, a
		or	a
		jp	p, get_item_status

		and	0Fh
		ld	e, a
		jr	nz, get_item_status

		ld	e, 3

get_item_status:
		GET_E_FROM_TABLE	3Fh

		PRINT_WITH_CODES

		inc	hl
		ld	a, (hl)
		or	a
		jr	z, next_item_in_list

		bit	7, d
		jr	z, print_list_item

print_unknown_type:
		RST_10_61	6Bh, 0Fh

		or	80h

print_list_item:
		PRINT_ITEM_NAME

next_item_in_list:
		PRINT_NEWLINE

		inc	b
		ld	a, b

		cp	8
		jr	c, loop_item_list

		ret
