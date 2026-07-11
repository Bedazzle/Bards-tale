; --- find_equipped_by_type -----------------------------------
; @done
; Scans a hero's 8 equipment slots for an item whose special-attribute
; low nibble (INX_ITEM_SPECATT & $0F) matches the requested type in e.
; On the first match it reports success (carry clear); if no slot
; matches it returns with carry set.
; In:  e = item type to match, ix = hero record
; Out: carry set = not found; carry clear + hl at the matching slot = found
find_equipped_by_type:
		FIND_ATTR_AND_ADDRESS	CHAR_LASTITEM_ID

		ld	b,8

.next_item:
		ld	d,(hl)
		dec	hl

		GET_D_FROM_TABLE	INX_ITEM_SPECATT

		and	$0F

		cp	e
		jr	nz,.skip

		ld	a,1

		cp	(hl)
		inc	hl
		ret	z

		dec	hl

.skip:
		dec	hl
		djnz	.next_item

		scf

		ret
