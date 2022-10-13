proc_roscoe:
		SHOW_NAME_AND_PICTURE	9, PIC_ROSCOES	; Roscoe's

loop_roscoe:
		CLEAR_INFO_PANEL

		PRINT2_IN_LOOP
		db  29h,   8,0FFh				; "Welcome, my friends, to Roscoe's Energy Emporium. Who needeth spell points restored? Enter (1-6) or"
										; "(E)xit"

loop_roscoe_hero:
		call	enter_hero_num
		jr	nc, roscoe_check_hero

		cp	'E'
		jr	nz, loop_roscoe_hero

		jp	process_exit
; -------------------------------------

roscoe_check_hero:
		CLEAR_INFO_PANEL

		PRINT_IX_HERO_NAME

		GET_ATTR_BY_PARAM	CHAR_SPPT_MAX_LO

		inc	hl
		inc	hl							; (HL) = SPPT current LO byte
		sub	(hl)
		ld	e, a
		ld	a, (ix+CHAR_SPPT_MAX_HI)	; SPPT max HI byte
		sub	(ix+CHAR_SPPT_HI)			; SPPT current HI byte
		ld	d, a
		jr	nz, need_restoration

		or	e
		jr	nz, need_restoration

		PRINT_MESSAGE2	7Eh				; "does not require restoration."

		CHANGE_SPEED 0Ah

		jr	loop_roscoe
; -------------------------------------

need_restoration:
		PRINT2_IN_LOOP
		db  7Fh, 5Dh,0FFh				; "has some definite spell point problems."
										; "It will cost"

		ld	bc, 0Fh
		ld	h, b
		ld	l, b

calc_restore_cost:
		add	hl, bc
		dec	de
		ld	a, d
		or	e
		jr	nz, calc_restore_cost

		ex	de, hl

		PRINT_NUM_FROM_DE

		PRINT_MESSAGE2	17h				; "Who will pay?"

		PRINT_MESSAGE	44h				; "(1-6)"

		GET_ATTR_BY_PARAM_SAVE_HL	CHAR_POS_IN_PARTY

		ld	c, a
		call	enter_hero_num
		jr	c, loop_roscoe

		PRINT_NEWLINE

		ld	e, CHAR_GOLD_START
		call	check_12_digits
		jr	nc, give_gold_roscoe

no_gold_roscoe:
		ld	b, c

		FIND_HERO_BY_B

		PRINT_MESSAGE	1Bh				; "Not enough"

		PRINT_MESSAGE	7Bh				; "gold"

		CHANGE_SPEED 0Eh

		jr	roscoe_check_hero
; -------------------------------------

give_gold_roscoe:
		ld	e, CHAR_GOLD_START
		call	decreas_12_digits
		ld	b, c

		FIND_HERO_BY_B

		ld	a, (ix+CHAR_SPPT_MAX_HI)
		ld	(ix+CHAR_SPPT_HI), a		; restore HI byte of SPPT to max
		ld	a, (ix+CHAR_SPPT_MAX_LO)
		ld	(ix+CHAR_SPPT_LO), a		; restore LO byte of SPPT to max

		PRINT_MESSAGE2	2Ah				; "Roscoe re-energizes him."

		CHANGE_SPEED_TO_8

		PRINT_STATS_TABLE

		jp	loop_roscoe
