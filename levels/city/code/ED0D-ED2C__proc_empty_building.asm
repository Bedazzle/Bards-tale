; --- proc_emptybuild ------------------------------------------
; @done
; Location handler for a generic empty building. On entry there is a
; 1-in-3 chance of an ambush (rolls a random value; on 0 sets the
; ambush flag and runs combat). Then it shows the "empty building"
; screen and waits for (E)xit, which leaves via process_exit.
proc_emptybuild:
		GET_RND_BY_PARAM	3

		jr	nz,no_ambush

		ld	(GAME_VARIABLES + VAR_AMBUSH_FLAG),a
		call	combat_foes

no_ambush:
		SHOW_NAME_AND_PICTURE	5,PIC_BUILDING		; Building

		CLEAR_INFO_PANEL

		PRINT2_IN_LOOP
		DB $20,8,$55,$FF				; You are in an empty building.
											; (E)xit
											; building

loop_empty_build:
		WAIT_KEY_DOWN

		cp	'E'
		jr	nz,loop_empty_build

		jp	process_exit
