check_equipped:
		call	get_param_to_A
		inc	(iy+VAR_PAUSE)		; pause ON

		PUSH_REGS

		ld	e, a

		FIND_HERO_BY_B

		jr	z, loc_6CF4

		FIND_ATTR_AND_ADDRESS	CHAR_ITEM_1_ID

		ld	b, 8				; items to check

loop_char_items:
		ld	a, (hl)

		GET_A_FROM_TABLE	INX_ITEM_EFFECTS

		cp	e
		jr	z, loc_6CF9

		inc	hl
		inc	hl
		djnz	loop_char_items

loc_6CF4:
		dec	(iy+VAR_PAUSE)		; pause OFF
		scf

		ret

loc_6CF9:
		dec	hl
		ld	a, (hl)
		and	0Fh
		xor	1
		and	1
		dec	(iy+VAR_PAUSE)		; pause OFF

		ret
