play_song:
		PRINT_WHO_WILL

		PRINT_CRLF_AND_MESSAGE	50h	; "play?"

		PRINT_MESSAGE	44h			; "(1-6)"

		CHOOSE_HERO

		ret	c

		ld	e, a

		GET_ATTR_BY_PARAM_SAVE_HL	CHAR_CLASS

		cp	CLASS_BARD
		jr	nz, not_a_bard

		call	loc_6D05
		jr	nc, check_can_sing

no_instrument:
		PRINT_CRLF_AND_MESSAGE	1Fh	; "He is not"

		PRINT_MESSAGE	7Dh			; "using an instrument!"

		jr	exit_song
; -------------------------------------

check_can_sing:
		CHECK_EQUIPPED	5

		jr	nc, loc_746D

		GET_ATTR_BY_PARAM	CHAR_BARD_SONGS

		jr	nz, choose_tune

cant_sing:
		PRINT_CRLF_AND_MESSAGE	20h	; "He has lost his voice! Try a cool drink..."

		jr	exit_song
; -------------------------------------

not_a_bard:
		PRINT_CRLF_AND_MESSAGE	1Fh	; "He is not"

		PRINT_MESSAGE	7Ch			; "a bard!"

exit_song:
		CHANGE_SPEED_TO_8

		ret
; -------------------------------------

choose_tune:
		dec	(hl)

loc_746D:
		PRINT_CRLF_AND_MESSAGE	1	; "Play tune"

		PRINT_MESSAGE	44h			; "(1-6)"

		WAIT_KEY_DOWN

		cp	'7'
		ret	nc

		sub	'1'
		jr	nc, loc_7481

		inc	a
		jp	z, sub_7A67

		ret
; -------------------------------------

loc_7481:
		push	af
		call	sub_7A67
		pop	af
		push	af
		ld	(GAME_VARIABLES + VAR_11), a

		GET_A_FROM_TABLE	0

		ld	(GAME_VARIABLES + VAR_1D), a
		ld	(iy+VAR_4C), e
		pop	af
		call	loc_82D7

		CLEAR_INFO_PANEL

		PRINT_IX_HERO_NAME

		PRINT_MESSAGE	75h			; "plays a tune..."

		CHANGE_SPEED 5

		GET_IY_A_FROM_TABLE	54h, 43h

		ld	b, a
		ld	a, (GAME_VARIABLES + VAR_11)

		cp	4
		jr	z, loc_74BA

		cp	1
		ret	nz

		ld	a, b
		add	a, 7

		GET_A_FROM_TABLE	4Ah

		ld	b, a

		jp	light_the_light
; -------------------------------------

loc_74BA:
		ld	(iy+VAR_57), b

		jp	dyn_proc_07
