; --- trade_gold ----------------------------------------------
; @done
; The (T)rade action from a hero's sheet. Offers "Trade Gold" (key
; 'G') or an item slot (1-8): trading gold prompts for an amount and a
; recipient and moves the gold between heroes; trading an item hands
; it to another hero (via the shared item-move at delete_hero_item). Reports
; "Not enough gold" or "Done!".
; In:  ix = source hero
trade_gold:
		PRINT_SPACE_LINE

		PRINT_IN_LOOP
		DB $15,$45,$FF			; "Trade Gold,"
									; "(1-8)"

		ENTER_1_TO_8

		jr	nc,check_is_equipped

		cp	'G'
		ret	nz

		PRINT_SPACE_LINE

		dec	(iy+VAR_CURSOR_ROW)
		call	input_text_line
		ret	c

		call	ascii_to_num
		ret	c

		ld	e,CHAR_GOLD_START
		call	check_12_digits
		jr	nc,ready_for_trade

		PRINT_SPACE_LINE

		PRINT_MESSAGE	$1B			; "Not enough"

		PRINT_MESSAGE	$7B			; "gold"

		jp	go_change_speed
; -------------------------------------

ready_for_trade:
		PRINT_SPACE_LINE

		PRINT_IN_LOOP
		DB $16,$44,$FF			; "To Who?"
									; "(1-6)"

		ENTER_1_TO_6

		ret	c
		push	ix

		FIND_HERO_BY_A

		push	ix
		pop	hl
		pop	ix
		ret	z

		ld	e,CHAR_GOLD_START
		call	decreas_12_digits
		push	ix
		push	hl
		pop	ix
		call	increas_12_digits
		pop	ix

		PRINT_SPACE_LINE

		PRINT_MESSAGE	$1C			; "Done!"

		jr	go_change_speed
; -------------------------------------

check_is_equipped:
		cp	1
		jp	z,thats_equipped

		ld	a,(hl)
		and	$F0
		ld	d,a
		inc	hl
		ld	a,(hl)
		or	a
		ret	z

		ld	e,a

		PRINT_SPACE_LINE

		PRINT_IN_LOOP
		DB $16,$44,$FF			; "To Who?"
									; "(1-6)"

		ENTER_1_TO_6

		ret	c

		call	all_full
		ret	z

		jp	c,go_change_speed

		dec	hl

; --- delete_hero_item ------------------------------------------------
; @done
; Delete/move an inventory item: shift the item records after (de) up
; over the slot at (de) using the block move, then zero the vacated
; last slot. Shared by trade_gold (give item) and drop_item (via
; use_and_break_item) to remove an inventory entry.
; In:  de -> slot to remove, hl -> current inventory position
; Note: purpose partially inferred.
delete_hero_item:
		ex	de,hl

		FIND_ATTR_AND_ADDRESS	CHAR_LASTITEM_STATE

		and	a
		sbc	hl,de
		ld	c,l
		push	de
		pop	hl
		ld	b,0
		jr	z,.zero_item

		inc	hl
		inc	hl
		ldir

		ex	de,hl

.zero_item:
		ld	(hl),b
		inc	hl
		ld	(hl),b

		ret
; -------------------------------------

; --- ascii_to_num --------------------------------------------
; @done
; Parse the digits typed into PARTY_HEADER into a 12-digit value at
; LEVEL_STOP+$A (used to enter a gold amount). Rejects a count > 12 or any
; non-digit character with carry set.
; In:  b = digit count
; Out: carry set on invalid input; LEVEL_STOP+$A = parsed number
ascii_to_num:
		push	bc

		NULLIFY_FB5B

		pop	bc
		ld	hl,LEVEL_STOP+$A
		ld	de,PARTY_HEADER
		ld	a,b

		cp	$0C
		ccf
		ret	c

		add	a,e
		ld	e,a
		jr	nc,loop_ascii_to_num

		inc	d

loop_ascii_to_num:
		ld	a,(de)
		sub	'0'
		ret	c

		cp	$0A
		ccf
		ret	c

		ld	(hl),a
		dec	hl
		dec	de
		djnz	loop_ascii_to_num

		ret
