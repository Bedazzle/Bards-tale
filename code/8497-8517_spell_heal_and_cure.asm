loc_8497:
		PUSH_REGS

		RST_10_49

		GET_IY_A_FROM_TABLE	4Bh, 4Ah

		and	7Fh
		push	af
		jr	z, loc_84AC

loc_84A4:
		GET_RND_BY_PARAM	3

		add	a, l
		inc	a
		ld	l, a
		djnz	loc_84A4

loc_84AC:
		ld	b, (iy+VAR_53)

		FIND_HERO_BY_B

		pop	af

		cp	0Fh
		jr	z, loc_84CA

		ld	e, (ix+CHAR_COND_LO)
		ld	d, (ix+CHAR_COND_HI)
		add	hl, de
		push	hl
		ld	e, (ix+CHAR_HITS_LO)
		ld	d, (ix+CHAR_HITS_HI)
		and	a
		sbc	hl, de
		pop	hl
		jr	c, loc_84D0

loc_84CA:
		ld	l, (ix+CHAR_HITS_LO)
		ld	h, (ix+CHAR_HITS_HI)

loc_84D0:
		ld	(ix+CHAR_COND_LO), l
		ld	(ix+CHAR_COND_HI), h

		GET_IY_A_FROM_TABLE	4Bh, 69h

		and	0E0h ; 'а'
		ret	z

		ld	b, a

		GET_ATTR_BY_PARAM_SAVE_HL	CHAR_STATUS		; get hero status

		bit	7, b				; ???
		jr	z, loc_84F1

		cp	STATUS_POISONED
		jr	z, set_status_ok

		cp	STATUS_PARALYZED
		jr	z, set_status_ok

		cp	STATUS_NUTS
		jr	z, set_status_ok

loc_84F1:
		ld	c, a
		ld	a, b

		cp	0E0h ; 'а'
		ld	a, c
		jr	nz, loc_84FC

		cp	3
		jr	z, loc_8505

loc_84FC:
		ld	c, a
		ld	a, b

		cp	0C0h ; 'А'
		ld	a, c
		ret	nz

		cp	6
		ret	nz

loc_8505:
		xor	a
		ld	(ix+CHAR_COND_LO), 1
		ld	(ix+CHAR_COND_HI), a
		ld	(ix+CHAR_FORMER_HEALTH), a

		GET_B_FROM_LIST	56h
; -------------------------------------

set_status_ok:
		ld	(ix+CHAR_STATUS), STATUS_OK
		ret
