movement:
		ld	a, (GAME_VARIABLES + VAR_PRESSED_KEY)
		ld	hl, GAME_VARIABLES + VAR_FACE_DIRECTION

		cp	'J'
		jr	z, turn_left

		cp	'L'
		jr	z, turn_right

		cp	'K'
		jr	z, kick_door

		cp	'I'
		jr	z, move_forward

		ret
; -------------------------------------

move_forward:
		ld	a, (byte_FBDF)
		and	7
		jr	z, loc_EF3F

		GET_GAME_VARIABLE	VAR_10		; ???

		ret	nz

		GET_GAME_VARIABLE	VAR_2E		; ???

		ret	nz

		ld	de, 32h			; duration
		ld	hl, 15h			; pitch

		jp	call_beeper
; -------------------------------------

kick_door:
		ld	a, (byte_FBDF)
		or	a
		jr	z, loc_EF3F

		push	af
		call	do_walk
		pop	af

		jp	loc_EFA3
; -------------------------------------

turn_left:
		dec	(hl)
		jp	p, move_execute

		ld	(hl), 3

		jr	move_execute
; -------------------------------------

turn_right:
		inc	(hl)
		ld	a, (hl)
		sub	4

		jr	nz, move_execute

		ld	(hl), a

move_execute:
		call	show_compass
		jp	dyn_proc_81
; -------------------------------------

do_walk:
		ld	a, (hl)
		or	a
		jr	z, go_north

		dec	a
		jr	z, go_east

		dec	a
		jr	z, go_south

go_west:
		dec	(iy+VAR_COORD_WE_EA)
		ret

go_north:
		inc	(iy+VAR_COORD_SO_NO)
		ret

go_south:
		dec	(iy+VAR_COORD_SO_NO)
		ret

go_east:
		inc	(iy+VAR_COORD_WE_EA)
		ret

; -------------------------------------

loc_EF3F:
		call	do_walk
		jr	move_execute
