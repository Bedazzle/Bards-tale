process_poison:
		ld	b, 6

loop_poisoned:
		FIND_HERO_BY_B

		jr	z, search_nxt_poison

		ld	a, (ix+CHAR_STATUS)
		dec	a
		jr	nz, search_nxt_poison

poisoned_char:
		GET_IY_A_FROM_TABLE	54h, 4Bh

		ld	c, a

		GET_ATTR_BY_PARAM	CHAR_COND_LO

		sub	c
		ld	(hl), a
		dec	hl
		ld	a, (hl)
		sbc	a, 0
		ld	(hl), a
		jr	nc, search_nxt_poison

		xor	a
		ld	(hl), a
		inc	hl
		ld	(hl), a
		ld	(ix+CHAR_STATUS), STATUS_DEAD

search_nxt_poison:
		dec	b
		jp	p, loop_poisoned

		jp	print_stats_table
