; --- shoppe_sell -------------------------------------------
; @done
; Garth's "Sell an item" service. Asks which of the hero's items (1-8)
; to sell, credits the sale price to his gold, bumps the shop's stock
; count for that item (unless it is already maxed), removes it from the
; hero and redraws, looping until cancelled (returns to loop_shoppe).
shoppe_sell:
		call	print_item_price

		PRINT_MESSAGE2	6	; "Sell item"

		PRINT_MESSAGE	$45	; "(1-8)"

		call	get_inventory_selection
		jr	c,loop_shoppe

		ld	c,e

.credit_gold:
		ld	e,CHAR_GOLD_START
		call	increas_12_digits

		GET_C_FROM_TABLE	$16

		cp	$FE
		jr	nc,.finish

		exx
		inc	(hl)
		exx

.finish:
		dec	hl
		call	delete_hero_item
		call	calc_armor_class

		jr	shoppe_sell
