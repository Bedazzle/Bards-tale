; --- proc_shoppe -------------------------------------------
; @done
; Top handler for Garth's Equipment Shoppe (location 3). Shows the shop
; name/picture; at night the shop is closed and it exits. By day it runs
; the main menu loop (loop_shoppe): pick a hero, then (B)uy / (S)ell /
; (I)dentify / (P)ool gold / (D)one, dispatching to the matching handler
; and looping until the party leaves.
; Note: loop_shoppe is the menu re-entry the sell/buy/identify handlers jump back to.
proc_shoppe:
		SHOW_NAME_AND_PICTURE	3,PIC_SHOPPE		; The Shoppe

shoppe_done:
		CLEAR_INFO_PANEL

		GET_GAME_VARIABLE	VAR_DAY_PART

		jr	z,shop_at_day

shop_at_night:
		PRINT2_IN_LOOP
		DB 2,$4C,$FF			; "Sorry friends, Garth's Shoppe is closed. Come back in the morning..."
									; "(Press a key to exit)"

		WAIT_KEY_DOWN

		jr	exit_shoppe
; -------------------------------------

shop_at_day:
		PRINT2_IN_LOOP
		DB 1,$57,8,$58,$FF	; "Welcome"
									; "to Garth's Equipment Shoppe, oh wealthy travellers!"
									; "(E)xit"
									; "shoppe."

shoppe_wait:
		call	enter_hero_num
		jr	nc,loop_shoppe

		cp	'E'						; exit shop
		jr	nz,shoppe_wait

exit_shoppe:
		jp	process_exit
; -------------------------------------

loop_shoppe:
		CLEAR_INFO_PANEL

		PRINT_MESSAGE2	3		; "Greetings,"

		PRINT_IX_HERO_NAME

		PRINT_MESSAGE2	$59		; "Would you like to:"

		ld	hl,$1507
		ld	(GAME_VARIABLES + VAR_CURSOR_ROW),hl

		PRINT_MESSAGE2	$5A		; "(B)uy an item (S)ell an item (I)dentify item (P)ool gold (D)one"

		PRINT_2_NEWLINES

		PRINT_CRLF_AND_MESSAGE	$32			; "Gold :"

		call	copy_hero_money
		call	print_large_number

		WAIT_KEY_DOWN

		cp	'D'
		jr	z,shoppe_done

		cp	'I'
		jr	z,shoppe_identify

		cp	'S'
		jr	z,shoppe_sell

		cp	'B'
		jr	z,shoppe_buy

		cp	'P'
		call	z,shoppe_pool_gold

		jr	loop_shoppe
