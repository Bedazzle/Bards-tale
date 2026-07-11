; --- proc_castle ----------------------------------------------
; @done
; Entry-chamber handler for Harkyn's Castle. Shows the chamber text
; and offers (T)ake stairs up or (E)xit. Sets the target level id
; ($0B) and drops into the shared wait_for_enter tail, which on (T)
; loads that level via load_file_by_id / insert_skara_tape.
proc_castle:
		SHOW_NAME_AND_PICTURE	$0B,PIC_TOWER	; Castle

		CLEAR_INFO_PANEL

		PRINT2_IN_LOOP
		DB $27,$4D,$28,8,$56,$FF	; "This is the entry chamber"
											; "to Harkyn's Castle. It is not guarded, but a sign threatens tresspassers with death."
											; "You can (T)ake stairs up"
											; "(E)xit"
											; "the castle"

		ld	b,$0B			; CASTLE_ID

		jr	wait_for_enter
; -------------------------------------

; --- proc_amber -----------------------------------------------
; @done
; Entry-chamber handler for Kylearan's Amber Tower. As proc_castle,
; but sets level id $0E before the shared wait_for_enter tail.
proc_amber:
		SHOW_NAME_AND_PICTURE	$0A,PIC_TOWER	; Amber Tower

		CLEAR_INFO_PANEL

		PRINT2_IN_LOOP
		DB $27,$4E,$28,8,$54,$FF	; "This is the entry chamber"
											; "to Kylearan's Amber Tower. A stairwell leads up to a lofty level of chambers."
											; "You can (T)ake stairs up"
											; "(E)xit"
											; "tower"

		ld	b,$0E			; AMBER_ID

		jr	wait_for_enter
; -------------------------------------

; --- proc_mangar_saved ----------------------------------------
; @done
; Entry handler for Mangar's Tower, which is warded. It scans all 6
; party slots for a hero with the required item equipped (equipped
; item $0E via CHECK_EQUIPPED). If none carry it, a disembodied
; voice refuses the party and exits (process_exit). If one does,
; it falls through to mangar_tower: shows the entrance and, on (T),
; loads level id $0F via the shared wait_for_enter tail.
proc_mangar_saved:
		ld	b,6

check_hero_mangar:
		CHECK_EQUIPPED	$0E

		jr	nc,mangar_tower
		djnz	check_hero_mangar

		FIND_INN	$0D

		CLEAR_INFO_PANEL

		PRINT_MESSAGE2	$2B			; "A voice from nowhere speaks to you: 'Despised ones, none save Mangar may enter his demesnes'"

		PRINT_MESSAGE2	$4C			; "(Press a key to exit)"

		WAIT_KEY_DOWN

		jr	process_exit
; -------------------------------------

mangar_tower:
		SHOW_NAME_AND_PICTURE	$0C,PIC_TOWER	; The Tower

		CLEAR_INFO_PANEL

		PRINT2_IN_LOOP
		DB $27,$4F,$28,8,$54,$FF	; "This is the entry chamber"
											; "to Kylearan's Amber Tower. A stairwell leads up to a lofty level of chambers."
											; "You can (T)ake stairs up"
											; "(E)xit"
											; "tower"

		ld	b,$0F

wait_for_enter:
		WAIT_KEY_DOWN

		cp	'T'
		jr	z,load_file_by_id

		cp	'E'
		jr	nz,wait_for_enter
		jr	process_exit
; -------------------------------------

load_file_by_id:
		ld	c,b			; given ID

		jp	insert_skara_tape
; -------------------------------------
