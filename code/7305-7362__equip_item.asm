; --- equip_item ----------------------------------------------
; @done
; The (E)quip action: "Equip 0 or (1-8)". 0 unequips every inventory
; slot; a slot number equips/toggles that item, first unequipping any
; other item of the same body slot, and rejects non-equippable items
; with "You can't use that.". Recomputes derived stats afterwards and
; refreshes combat if this hero is the active actor.
; In:  ix = hero
equip_item:
		PRINT_SPACE_LINE

		PRINT_IN_LOOP
		DB $19,$45,$FF			; "Equip 0 or"
									; "(1-8)"

		ENTER_1_TO_8

		jr	nc,.check_item

		inc	a
		ret	nz

		FIND_ATTR_AND_ADDRESS	CHAR_INVENTORY

		ld	c,8

.unequip_loop:
		call	unequip_slot
		dec	c
		jr	nz,.unequip_loop
		jr	finish_equip
; -------------------------------------

.check_item:
		inc	hl
		ld	a,(hl)
		or	a
		ret	z

		CHECK_ITEM_MASK	$6B,$0F

		ret	z

		ld	c,a
		dec	hl
		push	hl
		ld	a,(hl)
		and	$0F

		cp	2
		jr	nz,equip_for_use

		pop	hl

		PRINT_SPACE_LINE

		PRINT_MESSAGE	$11			; "You can't use that."

		jr	go_change_speed

equip_for_use:
		ld	b,8

		FIND_ATTR_AND_ADDRESS	CHAR_ITEM_1_ID

.scan_same:
		ld	a,(hl)

		CHECK_ITEM_MASK	$6B,$0F

		cp	c
		jr	nz,.next_item

		dec	hl
		call	unequip_slot
		dec	hl

.next_item:
		inc	hl
		inc	hl
		djnz	.scan_same

		pop	hl
		set	0,(hl)

finish_equip:
		call	calc_armor_class
		ld	a,b

		cp	(iy+VAR_CURRENT_ACTOR)
		ret	nz

		jp	process_special_event

; ======= S U B	R O U T	I N E =========


; --- unequip_slot --------------------------------------------
; @done
; Clear the "equipped" flag (bit 0) of the item record at (hl) and
; advance hl by one item (2 bytes) to the next slot.
; In:  hl -> item record
; Out: hl -> next item record
unequip_slot:
		res	0,(hl)
		inc	hl
		inc	hl

		ret
