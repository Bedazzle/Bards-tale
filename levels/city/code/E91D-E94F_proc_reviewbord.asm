proc_reviewbord:
		SHOW_NAME_AND_PICTURE	2, PIC_REVIEWBOARD		; Review Board

reset_reviewboard:
		CLEAR_INFO_PANEL

		GET_GAME_VARIABLE	VAR_DAY_PART

		jr	nz, review_closed

		PRINT2_IN_LOOP
		db  0Dh,   8, 0Eh,0FFh			; "Would thou like to be reviewed for (A)dvancement (S)pell Acquiring (C)lass Change"
										; "(E)xit"
										; "Review"

loop_reviewboard:
		WAIT_KEY_DOWN

		cp	'A'
		jr	z, do_advancement

		cp	'S'
		jp	z, do_spell_acquire

		cp	'C'
		jp	z, do_class_change

		cp	'E'
		jr	nz, loop_reviewboard
		jr	do_exit_review

; -------------------------------------

review_closed:
		PRINT2_IN_LOOP
		db  0Ch, 0Bh, 6Ah, 4Ch,0FFh		; "The Review Board is closed for the evening."
										; "The Guild leaders"
										; "will meet with you in the morning."
										; "(Press a key to exit)"

		WAIT_KEY_DOWN

do_exit_review:
		jp	process_exit
