; --- all_full ------------------------------------------------
; @done
; Test whether the target hero's inventory is full (add_item_to_hero). If it
; is, print "All full!" and return with carry set; otherwise return
; the carry result from add_item_to_hero (carry clear = space available).
; Out: carry set if inventory full
all_full:
		call	add_item_to_hero
		ret	nc

		or	a
		push	af

		PRINT_SPACE_LINE

		PRINT_MESSAGE	$1A			; "All full!"

		pop	af
		scf

		ret
