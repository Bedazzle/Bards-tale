equip_item:
		PRINT_SPACE_LINE

		PRINT_IN_LOOP
		db  19h, 45h, 0FFh			; "Equip 0 or"
									; "(1-8)"

		ENTER_1_TO_8

		jr	nc, loc_731F

		inc	a
		ret	nz

		FIND_ATTR_AND_ADDRESS	CHAR_INVENTORY

		ld	c, 8

loc_7317:
		call	sub_735E
		dec	c
		jr	nz, loc_7317
		jr	loc_7353
; -------------------------------------

loc_731F:
		inc	hl
		ld	a, (hl)
		or	a
		ret	z

		RST_10_61	6Bh, 0Fh

		ret	z

		ld	c, a
		dec	hl
		push	hl
		ld	a, (hl)
		and	0Fh

		cp	2
		jr	nz, equip_for_use

		pop	hl

		PRINT_SPACE_LINE

		PRINT_MESSAGE	11h			; "You can't use that."

		jr	go_change_speed

equip_for_use:
		ld	b, 8

		FIND_ATTR_AND_ADDRESS	CHAR_ITEM_1_ID

loc_733F:
		ld	a, (hl)

		RST_10_61	6Bh, 0Fh

		cp	c
		jr	nz, loc_734C

		dec	hl
		call	sub_735E
		dec	hl

loc_734C:
		inc	hl
		inc	hl
		djnz	loc_733F

		pop	hl
		set	0, (hl)

loc_7353:
		call	sub_75BF
		ld	a, b

		cp	(iy+VAR_4C)
		ret	nz

		jp	sub_7A67

; ======= S U B	R O U T	I N E =========


sub_735E:
		res	0, (hl)
		inc	hl
		inc	hl

		ret
