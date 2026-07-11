; --- proc_tavern ----------------------------------------------
; @done
; Entry for the Tavern city location: show its name and picture,
; print the greeting, then loop on a keypress - (O)rder a drink,
; (T)alk to the barkeep, or (E)xit back to the street.
proc_tavern:
		SHOW_NAME_AND_PICTURE	1,PIC_TAVERN		; Tavern

tavern_hello:
		CLEAR_INFO_PANEL

		PRINT2_IN_LOOP
		DB $19,8,$75,$FF			; "Hail, travelers! Step to the bar and I'll draw you a tankard."
										; "(E)xit"
										; "the tavern"

loop_tavern:
		WAIT_KEY_DOWN

		cp	'O'
		jr	z,order_drink

		cp	'T'
		jp	z,talk_barkeeper

		cp	'E'
		jr	nz,loop_tavern

		jp	process_exit
