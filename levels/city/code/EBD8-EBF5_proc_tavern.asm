proc_tavern:
		SHOW_NAME_AND_PICTURE	1, PIC_TAVERN		; Tavern

tavern_hello:
		CLEAR_INFO_PANEL

		PRINT2_IN_LOOP
		db  19h,   8, 75h,0FFh			; "Hail, travelers! Step to the bar and I'll draw you a tankard."
										; "(E)xit"
										; "the tavern"

loop_tavern:
		WAIT_KEY_DOWN

		cp	'O'
		jr	z, order_drink

		cp	'T'
		jp	z, talk_barkeeper

		cp	'E'
		jr	nz, loop_tavern

		jp	process_exit
