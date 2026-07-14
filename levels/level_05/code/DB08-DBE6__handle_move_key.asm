; --- handle_move_key ($DB08-$DBE6) ----------------------------------
; @done
; Dispatch[0]: read the movement/action key and act (move/turn/etc.).

handle_move_key:
		ld	a,(iy+$24)
		cp	$4C
		jr	z,.skip6
		cp	$4B
		jr	z,.skip8
		cp	$4A
		jr	z,.skip5
		cp	$49
		jp	z,.skip10
		cp	$44
		jp	z,.skip
		cp	$45
		ret	nz
		call	get_cell_feature
		and	$40
		jp	z,.skip13
		GET_GAME_VARIABLE $20
		jp	z,.skip13
		ld	a,($FA55)
		or	a
		jr	nz,.skip3
		jr	.skip4
.skip:
		call	get_cell_feature
		and	$20
		jr	z,.skip13
		GET_GAME_VARIABLE $20
		jr	nz,.skip2
		call	damage_all_groups
.skip2:
		ld	a,($FA55)
		or	a
		jr	nz,.skip4
.skip3:
		inc	(iy+$3B)
		jp	teleport_to_level
.skip4:
		dec	(iy+$3B)
		jp	p,teleport_to_level
		ld	hl,($FA53)
		ld	(coord_so_no),hl
		ld	a,($FA5F)
		ld	(face_direction),a
		xor	a
		ld	(teleport_mode),a
		ld	c,a
		ld	b,$FF
		jp	insert_skara_tape
.skip5:
		ld	a,(iy+3)
		dec	a
		jp	p,.skip7
		ld	a,3
		jr	.skip7
.skip6:
		ld	a,(iy+3)
		inc	a
		cp	4
		jr	nz,.skip7
		xor	a
.skip7:
		ld	(iy+3),a
		ld	(iy+$40),0
		jp	process_turn
.skip8:
		ld	a,(SPELL_SECRET_STATE)
		or	a
		jr	z,.skip11
		cp	2
		jr	nz,.skip9
.loop:
		call	move_beep
		jr	.skip11
.skip9:
		cp	3
		jr	nz,.skip14
		jr	.loop
.skip10:
		ld	a,(SPELL_SECRET_STATE)
		or	a
		jr	nz,.skip12
.skip11:
		GET_GAME_VARIABLE $3E
		jr	nz,.skip14
		call	move_party_forward
.skip12:
		CLEAR_INFO_PANEL
.skip13:
		jp	process_turn
.skip14:
		GET_GAME_VARIABLE $27
		jr	nz,.done
		inc	(iy+9)
		inc	(iy+$27)
		call	redraw_location
.done:
		GET_GAME_VARIABLE $10
		jr	nz,.skip15
		GET_GAME_VARIABLE $2E
		ret	nz
		ld	de,$32
		ld	hl,$15
		call	call_beeper
.skip15:
		GET_GAME_VARIABLE $09
		jr	z,process_turn
		dec	(iy+9)
		dec	(iy+$27)
		call	redraw_location
		jr	process_turn
