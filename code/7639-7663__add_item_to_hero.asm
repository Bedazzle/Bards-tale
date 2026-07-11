; --- add_item_to_hero -----------------------------------------------
; @done
; Adds an item to a hero's inventory: finds the hero by number,
; scans his 8 item slots for a free one, and stores the new item's
; id/flags there. Decides whether the item auto-equips from the
; class/equip tables ($46 / INX_ITEM_EQUIP).
; In:  a = hero number, d/e = item bytes to store
; Out: carry set (a incremented) if the inventory is full; otherwise
;      the item is written and a returned as a slot count.
add_item_to_hero:
		PUSH_REGS

		FIND_HERO_BY_A

		ret	z

		FIND_ATTR_AND_ADDRESS	CHAR_ITEM_1_ID

		ld	b,8
		xor	a

loop_hero_items:
		cp	(hl)
		jr	z,empty_item_slot

		inc	hl
		inc	hl
		djnz	loop_hero_items

		inc	a
		scf
		ret

empty_item_slot:
		ld	a,(ix+CHAR_CLASS)

		GET_A_FROM_TABLE	$46

		ld	c,a

		GET_E_FROM_TABLE	INX_ITEM_EQUIP

		and	c
		ld	a,2
		jr	z,.store_item

		xor	a

.store_item:
		or	d
		ld	(hl),e
		dec	hl
		ld	(hl),a
		inc	a

		ret
