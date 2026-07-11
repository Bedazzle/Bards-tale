; --- enter_1_to_6 --------------------------------------------
; @done
; Wait for a key and accept the digits '1'..'6', returning a = 1..6.
; Any other key returns with carry set. Dispatch handler $4D.
; Out: a = 1..6 and carry clear on valid; carry set otherwise
enter_1_to_6:
		WAIT_KEY_DOWN

		cp	'7'
		ccf
		ret	c

		sub	'1'
		ret	c

		inc	a

		ret

; -------------------------------------

; --- enter_1_to_8 --------------------------------------------
; @done
; Wait for a key and accept the digits '1'..'8' as an inventory slot.
; Converts the digit to the item attribute index (slot*2 +
; CHAR_INVENTORY), reads that item and returns its low nibble (item
; type). Carry set if the key is out of range. Dispatch handler $4C.
; Out: a = item type nibble, hl -> item attribute; carry set if invalid
enter_1_to_8:
		WAIT_KEY_DOWN

		cp	'9'
		ccf
		ret	c

		sub	'1'
		ret	c

		add	a,a
		add	a,CHAR_INVENTORY

		GET_ATTR_BY_A

		and	$0F

		ret
