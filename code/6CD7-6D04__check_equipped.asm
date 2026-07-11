; --- check_equipped ---------------------------------------
; @done
; Test whether a party member has an item granting a given effect
; (dynamic proc #43, one param). Reads the effect-id param, finds
; the hero in slot b and scans the 8 item slots, comparing each
; item's effect-table entry to the param.
; In:  b = hero slot, effect-id param (via get_param_to_A),
;      iy = game variables base
; Out: carry set if no such item (or slot empty); carry clear with
;      a = matched item's state flag if found
; Note: raises/lowers VAR_PAUSE around the scan
check_equipped:
		call	get_param_to_A
		inc	(iy+VAR_PAUSE)		; pause ON

		PUSH_REGS

		ld	e,a

		FIND_HERO_BY_B

		jr	z,loop_char_items.not_found

		FIND_ATTR_AND_ADDRESS	CHAR_ITEM_1_ID

		ld	b,8				; items to check

loop_char_items:
		ld	a,(hl)

		GET_A_FROM_TABLE	INX_ITEM_EFFECTS

		cp	e
		jr	z,.found

		inc	hl
		inc	hl
		djnz	loop_char_items

.not_found:
		dec	(iy+VAR_PAUSE)		; pause OFF
		scf

		ret

.found:
		dec	hl
		ld	a,(hl)
		and	$0F
		xor	1
		and	1
		dec	(iy+VAR_PAUSE)		; pause OFF

		ret
