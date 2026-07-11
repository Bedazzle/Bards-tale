; --- shoppe_identify ---------------------------------------
; @done
; Garth's "Identify item" service. Shows the price, asks which of the
; hero's items (1-8) to identify, and if he can afford it deducts the fee
; and clears the item's unidentified flag; otherwise reports "Not enough
; gold" and re-prompts. Returns to loop_shoppe on cancel.
shoppe_identify:
		call	print_item_price

		PRINT_MESSAGE2	7			; "Identify"

		PRINT_MESSAGE	$45			; "(1-8)"

		call	get_inventory_selection
		jr	c,loop_shoppe

		ld	e,CHAR_GOLD_START
		call	check_12_digits
		jr	nc,do_identify

		PRINT_SPACE_LINE

		PRINT_MESSAGE	$1B			; "Not enough"

		PRINT_MESSAGE	$7B			; "gold"

		CHANGE_SPEED $0A

		jr	shoppe_identify

do_identify:
		ld	e,CHAR_GOLD_START
		call	decreas_12_digits
		dec	hl
		ld	a,(hl)
		and	$0F
		ld	(hl),a

		jr	shoppe_identify
