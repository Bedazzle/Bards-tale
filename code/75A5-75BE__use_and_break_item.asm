; --- use_and_break_item -----------------------------------------------
; @done
; Uses an item and may destroy it. Entry variant taking the item
; slot index in a: fetches the item's wear/charge byte (masked),
; then falls into check_item_break.
; In:  a = item slot index, ix = hero record
use_and_break_item:
		inc	a

		GET_ATTR_BY_A

		CHECK_ITEM_MASK	$67,$7F

		dec	hl

		jr	check_item_break

; --- break_item -----------------------------------------------
; @done
; Alternate entry taking the item attribute offset in l; fetches the
; item byte, then falls into check_item_break.
; In:  l = item attribute offset, a = wear value, ix = hero record
break_item:
		push	af
		ld	a,l

		GET_ATTR_BY_A

		pop	af

; --- check_item_break ---------------------------------------
; @done
; Consumes the item (jp delete_hero_item). If the wear value is below '0'
; ($30) it first rolls a 1-in-64 chance to break the item; on a
; surviving roll it returns without consuming.
; In:  a = item wear value
check_item_break:
		cp	$30 ; '0'
		jr	nc,.use_item

		GET_RND_BY_PARAM	$3F		; 0-63, random chance to break used item

		ret	nz

.use_item:
		jp	delete_hero_item
