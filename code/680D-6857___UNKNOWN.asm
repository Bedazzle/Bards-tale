dyn_proc_87:				; RST_10_51
		PUSH_REGS

		ld	c, 7
		jr	loc_6817

loc_6813:
		PUSH_REGS

		ld	c, 3

loc_6817:
		ld	e, 7

		GET_RND_NUMBERS

		and	c
		ld	b, a

		cp	7
		jr	z, loc_6843

loc_6821:
		FIND_HERO_BY_B

		jr	z, loc_6843

		ld	a, b
		or	a
		jr	nz, loc_683A

		ld	a, (ENEMY+ENEMY_10)
		or	a
		jr	nz, loc_6843

		ld	a, (ENEMY+ENEMY_17)
		or	a
		jr	z, loc_683A

		GET_GAME_VARIABLE	VAR_66			; ???

		jr	nz, loc_6843

loc_683A:
		GET_B_FROM_TABLE	40h

		jr	nz, loc_6843

		CHECK_HERO_STATUS

		jr	c, loc_6856

loc_6843:
		inc	b
		dec	e
		jr	z, loc_6854

		ld	a, b

		cp	STATUS_STONED
		jr	z, loc_6850

		cp	STATUS_NUTS
		jr	c, loc_6821

loc_6850:
		ld	b, 0

		jr	loc_6821

loc_6854:
		ld	b, 1

loc_6856:
		ld	a, b

		ret
