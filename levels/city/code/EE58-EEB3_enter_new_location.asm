proc_castle:
		SHOW_NAME_AND_PICTURE	0Bh, PIC_TOWER	; Castle

		CLEAR_INFO_PANEL

		PRINT2_IN_LOOP
		db  27h, 4Dh, 28h,   8,	56h,0FFh	; "This is the entry chamber"
											; "to Harkyn's Castle. It is not guarded, but a sign threatens tresspassers with death."
											; "You can (T)ake stairs up"
											; "(E)xit"
											; "the castle"

		ld	b, 0Bh			; CASTLE_ID

		jr	wait_for_enter
; -------------------------------------

proc_amber:
		SHOW_NAME_AND_PICTURE	0Ah, PIC_TOWER	; Amber Tower

		CLEAR_INFO_PANEL

		PRINT2_IN_LOOP
		db  27h, 4Eh, 28h,   8,	54h,0FFh	; "This is the entry chamber"
											; "to Kylearan's Amber Tower. A stairwell leads up to a lofty level of chambers."
											; "You can (T)ake stairs up"
											; "(E)xit"
											; "tower"

		ld	b, 0Eh			; AMBER_ID

		jr	wait_for_enter
; -------------------------------------

proc_mangar_saved:
		ld	b, 6

check_hero_mangar:
		CHECK_EQUIPPED	0Eh

		jr	nc, mangar_tower
		djnz	check_hero_mangar

		FIND_INN	0Dh

		CLEAR_INFO_PANEL

		PRINT_MESSAGE2	2Bh			; "A voice from nowhere speaks to you: 'Despised ones, none save Mangar may enter his demesnes'"

		PRINT_MESSAGE2	4Ch			; "(Press a key to exit)"

		WAIT_KEY_DOWN

		jr	process_exit
; -------------------------------------

mangar_tower:
		SHOW_NAME_AND_PICTURE	0Ch, PIC_TOWER	; The Tower

		CLEAR_INFO_PANEL

		PRINT2_IN_LOOP
		db  27h, 4Fh, 28h,   8,	54h,0FFh	; "This is the entry chamber"
											; "to Kylearan's Amber Tower. A stairwell leads up to a lofty level of chambers."
											; "You can (T)ake stairs up"
											; "(E)xit"
											; "tower"

		ld	b, 0Fh

wait_for_enter:
		WAIT_KEY_DOWN

		cp	'T'
		jr	z, load_file_by_id

		cp	'E'
		jr	nz, wait_for_enter
		jr	process_exit
; -------------------------------------

load_file_by_id:
		ld	c, b			; given ID

		jp	insert_skara_tape
; -------------------------------------
