; --- talk_barkeeper -------------------------------------------
; @done
; Tavern "(T)alk" handler: pick a hero, ask for a tip (a 1-3 digit
; gold amount), and if he can afford it deduct the gold and print a
; random rumour from the barkeep - a larger tip shifts the roll
; toward the better lines.
; In:  ix -> selected hero record (set by enter_hero_num)
talk_barkeeper:
		CLEAR_INFO_PANEL

		PRINT_MESSAGE	$1E			; "Who will"

		PRINT_MESSAGE2	$74			; "talk to the barkeep?"

		PRINT_MESSAGE	$44			; "(1-6)"

		call	enter_hero_num

		jp	c,tavern_hello

		CLEAR_INFO_PANEL

		PRINT_MESSAGE2	$77			; "'Talk ain't cheap,' the barkeep says. How much will you tip him?"

		call	enter_text
		jr	c,jump_tavern_hello

		ld	a,b
		or	a
		jr	z,jump_tavern_hello

		cp	4
		jr	nc,jump_tavern_hello

		call	ascii_to_num
		jr	c,jump_tavern_hello

bar_check_gold:
		ld	e,CHAR_GOLD_START
		call	check_12_digits
		jr	nc,give_gold_bar

no_gold_barkeep:
		PRINT_2_NEWLINES

		PRINT_MESSAGE	$1B			; "Not enough"

		PRINT_MESSAGE	$7B			; "gold"

		CHANGE_SPEED_TO_8

		jr	jump_tavern_hello
; -------------------------------------

give_gold_bar:
		ld	e,CHAR_GOLD_START
		call	decreas_12_digits
		ld	hl,SOME_BUFF
		ld	bc,$0B00
		ld	d,c

loop_check_gold:
		ld	a,(hl)
		or	a
		jr	nz,nonzero_gold

		inc	hl
		dec	b
		inc	c
		ld	a,c

		cp	$0C
		jr	c,loop_check_gold

		PRINT_MESSAGE2	$78			; "'Money talks, buddy,' he says."

		CHANGE_SPEED_TO_8

		jr	jump_tavern_hello
; -------------------------------------

nonzero_gold:
		sla	b
		sla	b

		cp	5
		jr	c,small_money

		inc	b
		inc	b

small_money:
		CLEAR_INFO_PANEL

		GET_RND_BY_PARAM	3

		add	a,b

		GET_A_FROM_TABLE	$0B

		PRINT2_A_WITH_FLAG_0

		PRINT_MESSAGE2	$4B			; "the barkeep whispers."

		PRINT_AND_WAIT

		jr	jump_tavern_hello
