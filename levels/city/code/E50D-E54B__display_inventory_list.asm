; --- display_inventory_list ----------------------------------------------
; @done
; List a hero's inventory in the info panel: for each of the 8 slots that
; holds an item, print its number (1-8), a '.' separator, the item name
; (special-attack variant when flagged) and its price at column $21.
; Empty slots are skipped.
display_inventory_list:
		CLEAR_INFO_PANEL

		GET_ATTR_BY_PARAM	CHAR_INVENTORY

		ld	b,$31 ; '1'

.item_loop:
		ld	d,(hl)
		inc	hl
		ld	a,(hl)
		or	a
		jr	z,.next_item

		ld	e,a
		ld	a,b

		PRINT_WITH_CODES

		ld	a,'.'

		PRINT_WITH_CODES

		ld	a,d
		or	a
		ld	a,e
		jp	p,.show_name

		GET_E_FROM_TABLE	INX_ITEM_SPECATT

		and	$0F
		or	$80

.show_name:
		call	print_item_name_padded
		ld	(iy+VAR_CURSOR_COL),$21

		GET_E_FROM_TABLE	$13

		call	store_bcd_and_compare
		call	shift_price_buffer
		call	print_large_number

		PRINT_NEWLINE

.next_item:
		inc	b
		ld	a,b
		inc	hl

		cp	$39 ; '9'
		jr	c,.item_loop

		ret
