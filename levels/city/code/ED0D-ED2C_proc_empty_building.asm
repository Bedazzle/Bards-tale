proc_emptybuild:
		GET_RND_BY_PARAM	3

		jr	nz, no_ambush

		ld	(GAME_VARIABLES + VAR_5A), a
		call	combat_foes

no_ambush:
		SHOW_NAME_AND_PICTURE	5, PIC_BUILDING		; Building

		CLEAR_INFO_PANEL

		PRINT2_IN_LOOP
		db  20h,   8, 55h,0FFh				; You are in an empty building.
											; (E)xit
											; building

loop_empty_build:
		WAIT_KEY_DOWN

		cp	'E'
		jr	nz, loop_empty_build

		jp	process_exit
