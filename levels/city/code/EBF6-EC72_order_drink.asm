order_drink:
		CLEAR_INFO_PANEL

		PRINT_MESSAGE	1Eh			; "Who will"

		PRINT_MESSAGE2	73h			; "drink?"

		PRINT_MESSAGE	44h			; "(1-6)"

		call	enter_hero_num
		jr	c, tavern_hello

		CLEAR_INFO_PANEL

		PRINT_MESSAGE2	1Ah			; "Seat thyself,

		PRINT_IX_HERO_NAME

		PRINT_MESSAGE2	76h			; "We've got... (A)le (B)eer (M)ead (F)oul spirits (G)inger Ale"

		ld	hl, (GAME_VARIABLES + VAR_COORD_SO_NO)
		ld	de, 1C05h				; check for "Scarlet Bard" inn
									; E=5, number of drinks
		and	a
		sbc	hl, de					; TODO: Scarlet bard coords from city map data
		ld	b, e
		jr	nz, choose_drink

show_wine:
		PRINT_MESSAGE2	1Bh			; "(W)ine"

		inc	b

choose_drink:
		PRINT_MESSAGE2	1Fh			; "What'll it be?"

		WAIT_KEY_DOWN

		ld	hl, DRINKS_KEYS+4
		bit	1, b
		jr	z, loc_EC2D

		inc	hl

loc_EC2D:
		cp	(hl)
		jr	z, loc_EC35

		dec	hl
		djnz	loc_EC2D

		jr	tavern_hello
; -------------------------------------

loc_EC35:
		PRINT_2_NEWLINES

		ld	a, b

		cp	4
		jr	z, feel_not_well

		cp	5
		jr	z, girls_not_imprsd

		cp	6
		jr	z, go_for_bottle

not_bad:
		PRINT_MESSAGE2	79h			; "(Burp!) Not too bad."

		jr	check_bard_reset
; -------------------------------------

feel_not_well:
		PRINT_MESSAGE2	1Dh			; "You don't feel too well."

		jr	check_bard_reset
; -------------------------------------

girls_not_imprsd:
		PRINT_MESSAGE2	1Eh			; "The girls in the tavern are not impressed."

		CHANGE_SPEED_TO_8

		jp	tavern_hello
; -------------------------------------

go_for_bottle:
		PRINT_MESSAGE2	1Ch			; "The barkeep says, 'Go down to the cellar and pick out a bottle.'"

		CHANGE_SPEED_TO_8

		ld	c, 4
		ld	b, a

		jp	insert_skara_tape
; -------------------------------------

check_bard_reset:
		GET_ATTR_BY_PARAM_SAVE_HL	CHAR_CLASS

		cp	CLASS_BARD
		jr	nz, no_reset_songs

reset_songs:
		GET_ATTR_BY_PARAM_SAVE_HL	CHAR_LEVEL_LO

		ld	(ix+CHAR_BARD_SONGS), a

no_reset_songs:
		CHANGE_SPEED_TO_8

jump_tavern_hello:
		jp	tavern_hello
