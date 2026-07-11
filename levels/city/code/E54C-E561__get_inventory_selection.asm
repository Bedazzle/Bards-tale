; --- get_inventory_selection -----------------------------------------------
; @done
; Prompt for one of the current hero's 8 inventory slots (1-8) and
; price the chosen item, ready for the shoppe sell/identify handlers
; to credit or charge the gold.
; In:  ix = current hero
; Out: CF set = cancelled or the slot is empty; else CF clear,
;      e = item id and its price is left in the price buffer.
get_inventory_selection:
		ENTER_1_TO_8

		ret	c

		inc	hl
		ld	a,(hl)
		or	a
		jr	nz,.have_item

		scf

		ret

.have_item:
		ld	e,a

		GET_A_FROM_TABLE	$13

		call	store_bcd_and_compare
		call	shift_price_buffer
		and	a

		ret
