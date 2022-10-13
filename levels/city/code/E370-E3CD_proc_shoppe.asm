proc_shoppe:
		SHOW_NAME_AND_PICTURE	3, PIC_SHOPPE		; The Shoppe

shoppe_done:
		CLEAR_INFO_PANEL

		GET_GAME_VARIABLE	VAR_DAY_PART

		jr	z, shop_at_day

shop_at_night:
		PRINT2_IN_LOOP
		db    2, 4Ch,0FFh			; "Sorry friends, Garth's Shoppe is closed. Come back in the morning..."
									; "(Press a key to exit)"

		WAIT_KEY_DOWN

		jr	exit_shoppe
; -------------------------------------

shop_at_day:
		PRINT2_IN_LOOP
		db    1, 57h,	8, 58h,0FFh	; "Welcome"
									; "to Garth's Equipment Shoppe, oh wealthy travellers!"
									; "(E)xit"
									; "shoppe."

shoppe_wait:
		call	enter_hero_num
		jr	nc, loop_shoppe

		cp	'E'						; exit shop
		jr	nz, shoppe_wait

exit_shoppe:
		jp	process_exit
; -------------------------------------

loop_shoppe:
		CLEAR_INFO_PANEL

		PRINT_MESSAGE2	3		; "Greetings,"

		PRINT_IX_HERO_NAME

		PRINT_MESSAGE2	59h		; "Would you like to:"

		ld	hl, 1507h
		ld	(GAME_VARIABLES + VAR_CURSOR_ROW), hl

		PRINT_MESSAGE2	5Ah		; "(B)uy an item (S)ell an item (I)dentify item (P)ool gold (D)one"

		PRINT_2_NEWLINES

		PRINT_CRLF_AND_MESSAGE	32h			; "Gold :"

		call	copy_hero_money
		call	loc_88E5

		WAIT_KEY_DOWN

		cp	'D'
		jr	z, shoppe_done

		cp	'I'
		jr	z, shoppe_identify

		cp	'S'
		jr	z, shoppe_sell

		cp	'B'
		jr	z, shoppe_buy

		cp	'P'
		call	z, shoppe_pool_gold

		jr	loop_shoppe
