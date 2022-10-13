proc_mad_god:
		SHOW_NAME_AND_PICTURE	0, PIC_TEMPLE		; Temple

loop_god_outer:
		CLEAR_INFO_PANEL

		PRINT2_IN_LOOP
		db  25h,   8, 7Bh,0FFh		; This is the temple of the Mad God. What is thy business, unbeliever?  (S)peak to priest
									; (E)xit
									; the temple

loop_god_inner:
		WAIT_KEY_DOWN

		cp	'S'
		jr	z, speak_to_priest

		cp	'E'
		jr	nz, loop_god_inner
		jp	process_exit

speak_to_priest:
		CLEAR_INFO_PANEL

		PRINT_MESSAGE2	26h			; "Only those who know the name of the Mad one are welcome. What wilt thou say?"

		call	enter_text
		jr	c, loop_god_outer

		CLEAR_INFO_PANEL

		ld	a, b
		cp	GOD_NAME_END-GOD_NAME						; check length of entered text
		jr	nz, name_not_match

		PRINT_2_NEWLINES

		ld	b, GOD_NAME_END-GOD_NAME
		ld	hl, GOD_NAME_END-1
		ld	de, TEXT_BUFFER + GOD_NAME_END-GOD_NAME-1	; entered text, 5 for Tarjan


loop_mad_god_name:
		ld	a, (de)
		cp	(hl)
		jr	nz, name_not_match

		dec	hl
		dec	de
		djnz	loop_mad_god_name

		PRINT_MESSAGE2	7Dh			; "'Speak not the name of the High one so loudly, lest he awaken,' the priest says. 'Enter the catacombs, believer.'"

		CHANGE_SPEED_TO_8

		ld	c, 8
		ld	b, a

		jp	insert_skara_tape

name_not_match:
		PRINT_MESSAGE2	7Ch			; "'Quit thy babbling,' the priest says."

		CHANGE_SPEED_TO_8

		jr	loop_god_outer

; -------------------------------------
GOD_NAME:
	db 'TARJAN'         ; The Mad God's name
GOD_NAME_END:
; -------------------------------------
