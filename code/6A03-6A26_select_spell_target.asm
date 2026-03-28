loc_6A03:
		CHECK_ITEM_MASK	69h, 7

		cp	4
		ccf
		ret	c

		call	print_enemy_group
		ret	c

		ld	c, a

		PRINT_MESSAGE	5			; "Cast at"

		ld	a, c

		SELECT_TARGET

		ccf

		ret

print_enemy_group:
		push	af

		CLEAR_INFO_PANEL

		call	print_N_enemies
		ld	hl, 150Bh
		ld	(GAME_VARIABLES + VAR_CURSOR_ROW), hl
		pop	af
		and	a

		ret
