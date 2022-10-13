use_item:
		PRINT_WHO_WILL

		PRINT_MESSAGE	51h			; "use an item?"

		CHOOSE_HERO

		ret	c

		call	use_which_item
		ret	z

		jr	c, cant_use_that

		or	a
		jp	p, for_combat_only

		and	7Fh

		cp	10h
		jr	c, cant_use_that

		call	loc_75AF

		GET_A_FROM_TABLE	6Ah

		ld	(GAME_VARIABLES + VAR_4B), a

		RST_10_61	69h, 7

		cp	4
		jr	nc, loc_74FA

		push	af

		CLEAR_INFO_PANEL

		ld	(iy+VAR_CURSOR_ROW), 0Bh

		PRINT_MESSAGE	21h			; "Use on"

		pop	af

		RST_10_30

		ret	c

		ld	(GAME_VARIABLES + VAR_53), a

loc_74FA:
		CLEAR_INFO_PANEL

		call	spell_casting
		scf

		ret
; -------------------------------------

cant_use_that:
		PRINT_MESSAGE	11h			; "You can't use that."

		jr	change_speed_8

for_combat_only:
		PRINT_MESSAGE	22h			; "That's for combat only."

change_speed_8:
		CHANGE_SPEED 8

		ret
; -------------------------------------

use_which_item:
		call	print_hero_items

		PRINT_MESSAGE	3			; "Use item"

		PRINT_MESSAGE	45h			; "(1-8)"

		ENTER_1_TO_8

		jr	c, loc_7532

		sub	2
		ccf
		jr	z, loc_752E

		inc	hl
		ld	a, (hl)
		or	a
		ret	z

		dec	hl
		push	ix
		pop	de
		and	a
		sbc	hl, de

		GET_A_FROM_TABLE	INX_ITEM_EFFECTS

		and	a

loc_752E:
		ld	h, 0
		inc	h

		ret

loc_7532:
		xor	a

		ret
