; --- proc_guild ---------------------------------------------
; @done
; The Adventurers' Guild location handler. Resets the per-visit
; guild flags (shields, secret-reveal, light, day counter), draws
; the guild screen, then loops the menu: (C)reate, (R)emove,
; (L)oad, (S)ave or (E)xit. Exit is refused unless the party is
; non-empty and passes the roster check; on a valid exit it sets the
; clock to early morning and leaves via process_exit.
; In:  iy = game variables base
proc_guild:
		ld	b,4
		ld	hl,GAME_VARIABLES + VAR_SHIELD

loop_guild:
		ld	a,(hl)
		or	a
		jr	z,next_guild

		ld	(hl),1

next_guild:
		dec	hl
		djnz	loop_guild

		xor	a
		ld	(iy+VAR_REVEAL_SECRET),a
		inc	a
		ld	(GAME_VARIABLES + VAR_DAY_OUTER_CTR),a

		GET_GAME_VARIABLE	VAR_LIGHT

		jr	z,show_guild

		ld	(iy+VAR_LIGHT),1

show_guild:
		call	process_special_event

		SHOW_NAME_AND_PICTURE	$0F,PIC_GUILD	; The Guild

		CLEAR_INFO_PANEL

		PRINT2_IN_LOOP
		DB $14,$5B,8,0,$FF		; "Thou art"
										; "in the Guild of Adventurers. (C)reate char. (R)emove char. (L)oad party (S)ave party (Q)uit game"
										; "(E)xit"
										; "Guild."

loop_menu:
		WAIT_KEY_DOWN

		cp	'C'
		jp	z,create_char

		cp	'R'
		jp	z,remove_char

		cp	'L'
		jp	z,load_party

		cp	'S'
		jp	z,save_party

		cp	'E'
		jr	nz,loop_menu

exit_guild:
		GET_GAME_VARIABLE	VAR_PARTY_SIZE		; ???

		jr	c,loop_menu

		CHECK_ALL_HEROES

		xor	a
		or	b
		jr	z,loop_menu

		ld	(iy+VAR_DAY_OUTER),$1F		; 31 = early morning
		xor	a
		ld	(GAME_VARIABLES + VAR_DAY_PART),a
		ld	(GAME_VARIABLES + VAR_COPY_DAYPART),a

		jp	process_exit
