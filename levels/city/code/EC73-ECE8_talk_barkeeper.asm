talk_barkeeper:
		CLEAR_INFO_PANEL

		PRINT_MESSAGE	1Eh			; "Who will"

		PRINT_MESSAGE2	74h			; "talk to the barkeep?"

		PRINT_MESSAGE	44h			; "(1-6)"

		call	enter_hero_num

		jp	c, tavern_hello

		CLEAR_INFO_PANEL

		PRINT_MESSAGE2	77h			; "'Talk ain't cheap,' the barkeep says. How much will you tip him?"

		call	enter_text
		jr	c, jump_tavern_hello

		ld	a, b
		or	a
		jr	z, jump_tavern_hello

		cp	4
		jr	nc, jump_tavern_hello

		call	ascii_to_num
		jr	c, jump_tavern_hello

bar_check_gold:
		ld	e, CHAR_GOLD_START
		call	check_12_digits
		jr	nc, give_gold_bar

no_gold_barkeep:
		PRINT_2_NEWLINES

		PRINT_MESSAGE	1Bh			; "Not enough"

		PRINT_MESSAGE	7Bh			; "gold"

		CHANGE_SPEED_TO_8

		jr	jump_tavern_hello
; -------------------------------------

give_gold_bar:
		ld	e, CHAR_GOLD_START
		call	decreas_12_digits
		ld	hl, SOME_BUFF
		ld	bc, 0B00h
		ld	d, c

loop_check_gold:
		ld	a, (hl)
		or	a
		jr	nz, nonzero_gold

		inc	hl
		dec	b
		inc	c
		ld	a, c

		cp	0Ch
		jr	c, loop_check_gold

		PRINT_MESSAGE2	78h			; "'Money talks, buddy,' he says."

		CHANGE_SPEED_TO_8

		jr	jump_tavern_hello
; -------------------------------------

nonzero_gold:
		sla	b
		sla	b

		cp	5
		jr	c, small_money

		inc	b
		inc	b

small_money:
		CLEAR_INFO_PANEL

		GET_RND_BY_PARAM	3

		add	a, b

		GET_A_FROM_TABLE	0Bh

		PRINT2_A_WITH_FLAG_0

		PRINT_MESSAGE2	4Bh			; "the barkeep whispers."

		PRINT_AND_WAIT

		jr	jump_tavern_hello
