loc_6977:
		cp	1
		jr	nz, check_attack

		ld	a, (byte_FB99)
		or	a
		jr	z, loc_6987

		call	print_enemy_group

		PRINT_MESSAGE	9			; "Attack"

loc_6987:
		ld	a, 4
		jr	loc_6997

check_attack:
		cp	7
		jr	nz, check_playtune

		call	print_enemy_group

		PRINT_MESSAGE	9			; "Attack"

		ld	a, 1

loc_6997:
		RST_10_30

		jr	c, loc_6963
		jr	loc_6971

check_playtune:
		cp	5
		jr	nz, battle_play_tune

		xor	a

		GET_B_FROM_LIST	40h

		CHECK_EQUIPPED	6

		jr	nc, loc_69B1

		GET_RND_NUMBERS

		cp	(ix+CHAR_ROGUE_HIDE)
		jr	nc, loc_69D2

loc_69B1:
		ld	a, 1

		GET_B_FROM_LIST	40h

		jr	loc_69D2
