; --- play_song -----------------------------------------------
; @done
; The (B)ard-song action: pick a hero, verify they are a Bard holding
; an instrument and still have their voice, then choose a tune (1-6)
; and play it, applying the tune's effect (light, combat buff, etc.).
; Emits the matching failure message otherwise.
play_song:
		PRINT_WHO_WILL

		PRINT_CRLF_AND_MESSAGE	$50	; "play?"

		PRINT_MESSAGE	$44			; "(1-6)"

		CHOOSE_HERO

		ret	c

		ld	e,a

		GET_ATTR_BY_PARAM_SAVE_HL	CHAR_CLASS

		cp	CLASS_BARD
		jr	nz,not_a_bard

		call	find_special_weapon
		jr	nc,check_can_sing

no_instrument:
		PRINT_CRLF_AND_MESSAGE	$1F	; "He is not"

		PRINT_MESSAGE	$7D			; "using an instrument!"

		jr	exit_song
; -------------------------------------

check_can_sing:
		CHECK_EQUIPPED	5

		jr	nc,play_tune_prompt

		GET_ATTR_BY_PARAM	CHAR_BARD_SONGS

		jr	nz,choose_tune

cant_sing:
		PRINT_CRLF_AND_MESSAGE	$20	; "He has lost his voice! Try a cool drink..."

		jr	exit_song
; -------------------------------------

not_a_bard:
		PRINT_CRLF_AND_MESSAGE	$1F	; "He is not"

		PRINT_MESSAGE	$7C			; "a bard!"

exit_song:
		CHANGE_SPEED_TO_8

		ret
; -------------------------------------

choose_tune:
		dec	(hl)

play_tune_prompt:
		PRINT_CRLF_AND_MESSAGE	1	; "Play tune"

		PRINT_MESSAGE	$44			; "(1-6)"

		WAIT_KEY_DOWN

		cp	'7'
		ret	nc

		sub	'1'
		jr	nc,.selected

		inc	a
		jp	z,process_special_event

		ret
; -------------------------------------

.selected:
		push	af
		call	process_special_event
		pop	af
		push	af
		ld	(GAME_VARIABLES + VAR_SPELL_ID),a

		GET_A_FROM_TABLE	0

		ld	(GAME_VARIABLES + VAR_BARD_SONG_LVL),a
		ld	(iy+VAR_CURRENT_ACTOR),e
		pop	af
		call	start_spell_or_song

		CLEAR_INFO_PANEL

		PRINT_IX_HERO_NAME

		PRINT_MESSAGE	$75			; "plays a tune..."

		CHANGE_SPEED 5

		GET_IY_A_FROM_TABLE	$54,$43

		ld	b,a
		ld	a,(GAME_VARIABLES + VAR_SPELL_ID)

		cp	4
		jr	z,set_song_effect

		cp	1
		ret	nz

		ld	a,b
		add	a,7

		GET_A_FROM_TABLE	$4A

		ld	b,a

		jp	light_the_light
; -------------------------------------

set_song_effect:
		ld	(iy+VAR_SONG_EFFECT),b

		jp	recalc_party_ac
