proc_guild:
		ld	b, 4
		ld	hl, GAME_VARIABLES + VAR_SHIELD

loop_guild:
		ld	a, (hl)
		or	a
		jr	z, next_guild

		ld	(hl), 1

next_guild:
		dec	hl
		djnz	loop_guild

		xor	a
		ld	(iy+VAR_REVEAL_SECRET), a
		inc	a
		ld	(GAME_VARIABLES + VAR_04), a

		GET_GAME_VARIABLE	VAR_LIGHT

		jr	z, show_guild

		ld	(iy+VAR_LIGHT), 1

show_guild:
		call	sub_7A67

		SHOW_NAME_AND_PICTURE	0Fh, PIC_GUILD	; The Guild

		CLEAR_INFO_PANEL

		PRINT2_IN_LOOP
		db  14h, 5Bh,	8,   0,0FFh		; "Thou art"
										; "in the Guild of Adventurers. (C)reate char. (R)emove char. (L)oad party (S)ave party (Q)uit game"
										; "(E)xit"
										; "Guild."

loop_menu:
		WAIT_KEY_DOWN

		cp	'C'
		jp	z, create_char

		cp	'R'
		jp	z, remove_char

		cp	'L'
		jp	z, load_party

		cp	'S'
		jp	z, save_party

		cp	'E'
		jr	nz, loop_menu

exit_guild:
		GET_GAME_VARIABLE	VAR_00		; ???

		jr	c, loop_menu

		RST_10_2E

		xor	a
		or	b
		jr	z, loop_menu

		ld	(iy+VAR_DAY_OUTER),	1Fh		; 31 = early morning
		xor	a
		ld	(GAME_VARIABLES + VAR_DAY_PART), a
		ld	(GAME_VARIABLES + VAR_COPY_DAYPART), a

		jp	process_exit
