; --- order_drink ----------------------------------------------
; @done
; Tavern "(O)rder" handler: pick a hero, list the drinks on offer
; (adding (W)ine only at the Scarlet Bard inn), read the choice and
; play out its effect - most just print a quip, foul spirits make
; you ill, and one drink starts the cellar-bottle sub-load. A Bard
; has his song count refreshed by drinking.
; In:  ix -> selected hero record (set by enter_hero_num)
order_drink:
		CLEAR_INFO_PANEL

		PRINT_MESSAGE	$1E			; "Who will"

		PRINT_MESSAGE2	$73			; "drink?"

		PRINT_MESSAGE	$44			; "(1-6)"

		call	enter_hero_num
		jr	c,tavern_hello

		CLEAR_INFO_PANEL

		PRINT_MESSAGE2	$1A			; "Seat thyself,

		PRINT_IX_HERO_NAME

		PRINT_MESSAGE2	$76			; "We've got... (A)le (B)eer (M)ead (F)oul spirits (G)inger Ale"

		ld	hl,(GAME_VARIABLES + VAR_COORD_SO_NO)
		ld	de,$1C05				; check for "Scarlet Bard" inn
									; E=5, number of drinks
		and	a
		sbc	hl,de					; TODO: Scarlet bard coords from city map data
		ld	b,e
		jr	nz,choose_drink

show_wine:
		PRINT_MESSAGE2	$1B			; "(W)ine"

		inc	b

choose_drink:
		PRINT_MESSAGE2	$1F			; "What'll it be?"

		WAIT_KEY_DOWN

		ld	hl,DRINKS_KEYS+4
		bit	1,b
		jr	z,.match_key

		inc	hl

.match_key:
		cp	(hl)
		jr	z,.drink_chosen

		dec	hl
		djnz	.match_key

		jr	tavern_hello
; -------------------------------------

.drink_chosen:
		PRINT_2_NEWLINES

		ld	a,b

		cp	4
		jr	z,feel_not_well

		cp	5
		jr	z,girls_not_imprsd

		cp	6
		jr	z,go_for_bottle

not_bad:
		PRINT_MESSAGE2	$79			; "(Burp!) Not too bad."

		jr	check_bard_reset
; -------------------------------------

feel_not_well:
		PRINT_MESSAGE2	$1D			; "You don't feel too well."

		jr	check_bard_reset
; -------------------------------------

girls_not_imprsd:
		PRINT_MESSAGE2	$1E			; "The girls in the tavern are not impressed."

		CHANGE_SPEED_TO_8

		jp	tavern_hello
; -------------------------------------

go_for_bottle:
		PRINT_MESSAGE2	$1C			; "The barkeep says, 'Go down to the cellar and pick out a bottle.'"

		CHANGE_SPEED_TO_8

		ld	c,4
		ld	b,a

		jp	insert_skara_tape
; -------------------------------------

check_bard_reset:
		GET_ATTR_BY_PARAM_SAVE_HL	CHAR_CLASS

		cp	CLASS_BARD
		jr	nz,no_reset_songs

reset_songs:
		GET_ATTR_BY_PARAM_SAVE_HL	CHAR_LEVEL_LO

		ld	(ix+CHAR_BARD_SONGS),a

no_reset_songs:
		CHANGE_SPEED_TO_8

jump_tavern_hello:
		jp	tavern_hello
