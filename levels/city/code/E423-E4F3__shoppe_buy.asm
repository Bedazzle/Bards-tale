; --- shoppe_buy --------------------------------------------
; @done
; Garth's "Buy an item" screen. Pages through the shop's stock (c = page
; start), listing up to 9 items each with a class-usability marker
; ('.' usable / '^' not) and its price. Menu: (P)urchase / (F)orward /
; (B)ack. On purchase it maps the pressed digit to an item, checks the
; hero's gold and free inventory space, deducts the price, adds the item
; and decrements stock, then rebuilds the list.
shoppe_buy:
		ld	c,1

		CLEAR_INFO_PANEL

start_buy:
		RESET_ROW_COL

		ld	b,0
		ld	l,c

.list_loop:
		GET_L_FROM_TABLE	$16

		jr	z,.next_slot
		
		ld	a,b

		PRINT_NEXT_DIGIT

		GET_ATTR_BY_PARAM_SAVE_HL	CHAR_CLASS

		GET_A_FROM_TABLE	$46

		ld	h,a

		GET_L_FROM_TABLE	INX_ITEM_EQUIP

		and	h
		jr	nz,.can_use

		ld	a,$5E ; '^'

		jr	.print_marker
; -------------------------------------

.can_use:
		ld	a,$2E ; '.'

.print_marker:
		PRINT_WITH_CODES

		ld	a,l
		call	print_item_name_padded
		call	format_item_price
		ld	a,$28 ; '('
		call	print_spaces_eol

		PRINT_NEWLINE

		inc	b

.next_slot:
		inc	l
		ld	a,l
		and	$7F
		ld	l,a
		ld	a,b

		cp	9
		jr	c,.list_loop

		call	print_gold_line

shoppe_menu:
		RESET_COL

		ld	(iy+VAR_CURSOR_ROW),$0E

		PRINT_MESSAGE2	4		; "P)urc F)orw B)ack"

		WAIT_KEY_DOWN

		cp	'P'
		jr	z,purchase

		cp	'F'
		jr	z,shoppe_forw

		cp	'B'
		jp	nz,loop_shoppe

shoppe_back:
		dec	c
		jp	m,shoppe_back

		GET_C_FROM_TABLE	$16

		jr	z,shoppe_back
		jr	start_buy
; -------------------------------------

shoppe_forw:
		inc	c
		jp	m,shoppe_forw

		GET_C_FROM_TABLE	$16

		jr	z,shoppe_forw
		jr	start_buy
; -------------------------------------

purchase:
		PRINT_SPACE_LINE

		PRINT_MESSAGE2	5		; "Purchase (1-9)"

		RESET_COL

		WAIT_KEY_DOWN

		sub	'1'
		jr	c,shoppe_menu

		cp	9
		jr	nc,shoppe_menu

		ld	h,0
		ld	e,c

.seek_item:
		cp	h
		jr	z,.buy_item

		inc	h
		push	af

.skip_empty:
		inc	e
		jp	m,.skip_empty

		GET_E_FROM_TABLE	$16

		jr      z,.skip_empty

		pop	af
		jr	.seek_item
; -------------------------------------

.buy_item:
		GET_E_FROM_TABLE	$13

		push	de
		ld	e,CHAR_GOLD_START
		call	store_bcd_and_compare
		pop	de
		jr	nc,.do_buy

		PRINT_MESSAGE	$1B			; "Not enough"

		PRINT_MESSAGE	$7B			; "gold"

.buy_fail:
		CHANGE_SPEED $0A

		jr	shoppe_menu
; -------------------------------------

.do_buy:
		ld	d,0

		GET_ATTR_BY_PARAM_SAVE_HL	CHAR_POS_IN_PARTY

		call	all_full
		jr	c,.buy_fail

		ld	h,e
		ld	e,CHAR_GOLD_START
		call	decreas_12_digits

		PRINT_SPACE_LINE

		PRINT_MESSAGE	$1C			; "Done!"

		CHANGE_SPEED $0A

		GET_H_FROM_TABLE	$16

		cp	$FE
		jr	nc,.refresh

		exx
		dec	(hl)
		exx

.refresh:
		jp	start_buy
