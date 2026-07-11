; --- format_item_price -----------------------------------------------
; @done
; Print one shoppe item's buy price right-aligned at column 33:
; look the price up from table $13 by item index, convert it to BCD
; (store_bcd_and_compare) and print it (print_large_number). Called per row by shoppe_buy.
; In:  l = item index
format_item_price:
		ld	(iy+VAR_CURSOR_COL),$21		; 33

		GET_L_FROM_TABLE	$13

		call	store_bcd_and_compare

		jp	print_large_number
