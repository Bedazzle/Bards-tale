; --- print_item_price ---------------------------------------
; @done
; Draw the sell/identify screen header: list the current hero's
; inventory (via display_inventory_list), then print the hero's gold total on the
; line below. Called by shoppe_sell and shoppe_identify before the
; item prompt.
; In:  ix = current hero
print_item_price:
		call	display_inventory_list

		RESET_COL

		ld	(iy+VAR_CURSOR_ROW),$0C

; --- print_gold_line -----------------------------------------------
; @done
; Print the "Gold :" label followed by the current hero's 12-digit
; gold amount at the current cursor. Alternate entry point, also
; called stand-alone by shoppe_buy after listing the wares.
; In:  ix = current hero
print_gold_line:
		PRINT_CRLF_AND_MESSAGE	$32			; "Gold :"

		ld	e,CHAR_GOLD_START

		jp	print_12_digits
