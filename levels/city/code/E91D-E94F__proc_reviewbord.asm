; --- proc_reviewbord -----------------------------------------
; @done
; Review Board location handler. Shows the board name/picture, then
; (if it is not evening) offers the (A)dvancement / (S)pell / (C)lass
; change menu, dispatching to do_advancement, do_spell_acquire or
; do_class_change; (E) exits. Outside opening hours it prints the
; "closed for the evening" notice and exits on any key.
; Note: entered via the dynamic location-procedure dispatch (iy = game vars).
proc_reviewbord:
		SHOW_NAME_AND_PICTURE	2,PIC_REVIEWBOARD		; Review Board

reset_reviewboard:
		CLEAR_INFO_PANEL

		GET_GAME_VARIABLE	VAR_DAY_PART

		jr	nz,review_closed

		PRINT2_IN_LOOP
		DB $0D,8,$0E,$FF			; "Would thou like to be reviewed for (A)dvancement (S)pell Acquiring (C)lass Change"
										; "(E)xit"
										; "Review"

loop_reviewboard:
		WAIT_KEY_DOWN

		cp	'A'
		jr	z,do_advancement

		cp	'S'
		jp	z,do_spell_acquire

		cp	'C'
		jp	z,do_class_change

		cp	'E'
		jr	nz,loop_reviewboard
		jr	do_exit_review

; -------------------------------------

review_closed:
		PRINT2_IN_LOOP
		DB $0C,$0B,$6A,$4C,$FF		; "The Review Board is closed for the evening."
										; "The Guild leaders"
										; "will meet with you in the morning."
										; "(Press a key to exit)"

		WAIT_KEY_DOWN

do_exit_review:
		jp	process_exit
