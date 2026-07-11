; --- find_special_weapon  (find_special_weapon) ----------------------
; @done
; Scan a hero's 8 item slots for a usable 'special weapon'
; (special-attack type 6 with the item's low-nibble state = 1) and
; return its effect id. Used by the battle options and the bard's
; song code.
; In:  b = hero slot, iy = game variables base
; Out: carry clear with a = item effect id if found; carry set if
;      the hero carries no such weapon
find_special_weapon:
		PUSH_REGS

		FIND_HERO_BY_B

		FIND_ATTR_AND_ADDRESS	CHAR_ITEM_1_ID

		ld	b,8

.check_item:
		ld	c,(hl)

		GET_C_FROM_TABLE	INX_ITEM_SPECATT

		and	$0F

		cp	6
		jr	nz,.next_item

		dec	hl
		ld	a,(hl)
		and	$0F

		cp	1
		inc	hl
		jr	nz,.next_item

		GET_C_FROM_TABLE	INX_ITEM_EFFECTS

		and	a

		ret

.next_item:
		inc	hl
		inc	hl
		djnz	.check_item

		scf

		ret
