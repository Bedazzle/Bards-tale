; --- show_location_info -------------------------------------
; @done
; Print the party's current location into the info panel. Always
; starts with "You face <direction>". Underground it then prints
; the dungeon level and the N-S / W-E square offsets from the entry
; stairs ("...on level N, X squares below/above, Y squares ... of
; the entry stairs."); in the city it prints "in Skara Brae."
; instead. Finishes via print_and_wait.
; In:  iy = game variables (VAR_FACE_DIRECTION / coords / VAR_TELEPORT_MODE)
show_location_info:
		ld      a,(GAME_VARIABLES + VAR_FACE_DIRECTION)
		add     a,$BA ; '¦'
		ld      e,a
		ld      hl,GAME_VARIABLES + VAR_DISPLAY_COUNT

		CLEAR_INFO_PANEL

		GET_GAME_VARIABLE	VAR_UNDERGROUND

		jr	z,.in_city
		call	show_you_are

		PRINT_MESSAGE	$6D			; "and are"

		ld	a,(GAME_VARIABLES + VAR_TELEPORT_MODE)
		ld	(hl),a
		dec	(hl)

		PRINT_DIGIT

		PRINT_MESSAGE	$6E			; "level"

		ld	a,(CITY_MAP_DATA+$026E)
		or	a
		jr	z,.below

		PRINT_MESSAGE	$70			; "above,"

		jr	.print_ns_coord

.below:
		PRINT_MESSAGE	$6F			; "below,"

.print_ns_coord:
		ld	e,(iy+VAR_COORD_SO_NO)
		ld	(hl),e
		dec	(hl)

		PRINT_NUM_FROM_E

		PRINT_MESSAGE	$71			; "square"

		ld	a,$BA

		PRINT_WORD

		PRINT_SPACE

		ld	e,(iy+VAR_COORD_WE_EA)
		ld	(hl),e
		dec	(hl)

		PRINT_NUM_FROM_E

		PRINT_MESSAGE	$71			; "square"

		ld	a,$BB

		PRINT_WORD

		PRINT_MESSAGE	$72			; "of the entry stairs."

		jr	.done
; -------------------------------------

.in_city:
		call	show_you_are

		PRINT_MESSAGE	$74			; "in Skara Brae."

.done:
		jp	print_and_wait
; -------------------------------------

show_you_are:
		PRINT_MESSAGE	$23			; "You face"

		ld	a,e

		jp	print_word
