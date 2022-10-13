loc_7FB3:
		call	is_roster_full
		ret	c

		push	ix
		pop	hl

loc_7FBA:
		RST_10_51

		or	a
		jr	z, loc_7FBA

		FIND_HERO_BY_A

		ld	b, 64h 		; 100
		push	hl
		push	ix

loc_7FC6:
		ld	a, (ix+CHAR_NAME)
		ld	(hl), a
		inc	hl
		inc	ix
		djnz	loc_7FC6

		pop	ix
		pop	hl

		GET_RND_NUMBERS

		srl	a
		jr	nc, loc_7FDB

		push	hl
		pop	ix

loc_7FDB:
		ld	b, (iy+VAR_4E)
		xor	a

		GET_B_FROM_LIST	36h

		inc	a
		ld	(ix+CHAR_NEG_FLAG), a
		ld	(ix+CHAR_FORMER_HEALTH), a

		PRINT_MESSAGE	77h		; "jumps into your party!"

		PRINT_STATS_TABLE

		RST_10_29

		and	a

		ret
