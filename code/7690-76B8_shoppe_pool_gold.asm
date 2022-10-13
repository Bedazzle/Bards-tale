shoppe_pool_gold:
		PUSH_REGS

		FIND_ATTR_AND_ADDRESS	CHAR_GOLD_END

		ex	de, hl

		EXEC_FOR_HEROES	loc_769B

		ret

; -------------------------------------

loc_769B:
		push	de

		FIND_ATTR_AND_ADDRESS	CHAR_GOLD_END

		push	hl
		and	a
		sbc	hl, de
		pop	hl
		jr	z, loc_76B7

		ld	c, 0Ch		; 12 digits

pool_nxt_gold_dig:
		ld	a, (de)
		add	a, (hl)
		ld	(de), a		; gold to recipient
		ld	(hl), 0		; from donor
		dec	hl
		dec	de
		dec	c
		jr	nz, pool_nxt_gold_dig

		ex	de, hl
		push	bc

		CONVERT_12_DIGITS

		pop	bc

loc_76B7:
		pop	de

		ret
