; --- handle_move_key ($DC19-$DCF7) -----------------------------
; @done
; Dispatch[0]: read the movement/action key and act (move/turn/etc.).

handle_move_key:
		ld	a,(iy+$24)		; the pressed key
		cp	'L'			; turn right
		jr	z,.turn_right
		cp	'K'
		jr	z,.key_k
		cp	'J'			; turn left
		jr	z,.turn_left
		cp	'I'			; move forward
		jp	z,.move_fwd
		cp	'D'			; descend stairs
		jp	z,.use_stairs
		cp	'E'			; enter/ascend stairs
		ret	nz
		call	get_cell_feature
		and	$40
		jp	z,.end_turn
		GET_GAME_VARIABLE $20
		jp	z,.end_turn
		ld	a,(special_loc_list+$15)
		or	a
		jr	nz,.stairs_down
		jr	.stairs_up
.use_stairs:
		call	get_cell_feature
		and	$20
		jr	z,.end_turn
		GET_GAME_VARIABLE $20
		jr	nz,.stairs_ok
		call	damage_all_groups
.stairs_ok:
		ld	a,(special_loc_list+$15)
		or	a
		jr	nz,.stairs_up
.stairs_down:
		inc	(iy+$3B)
		jp	teleport_to_level
.stairs_up:
		dec	(iy+$3B)
		jp	p,teleport_to_level
		ld	hl,(special_loc_list+$13)
		ld	(coord_so_no),hl
		ld	a,(special_loc_list+$1F)
		ld	(face_direction),a
		xor	a
		ld	(teleport_mode),a
		ld	c,a
		ld	b,$FF
		jp	insert_skara_tape
.turn_left:
		ld	a,(iy+3)
		dec	a
		jp	p,.set_facing
		ld	a,3
		jr	.set_facing
.turn_right:
		ld	a,(iy+3)
		inc	a
		cp	4
		jr	nz,.set_facing
		xor	a
.set_facing:
		ld	(iy+3),a
		ld	(iy+$40),0
		jp	process_turn
.key_k:
		ld	a,(SPELL_SECRET_STATE)
		or	a
		jr	z,.try_step
		cp	2
		jr	nz,.k_check
.k_beep:
		call	move_beep
		jr	.try_step
.k_check:
		cp	3
		jr	nz,.bump
		jr	.k_beep
.move_fwd:
		ld	a,(SPELL_SECRET_STATE)
		or	a
		jr	nz,.redraw_move
.try_step:
		GET_GAME_VARIABLE $3E
		jr	nz,.bump
		call	move_party_forward
.redraw_move:
		CLEAR_INFO_PANEL
.end_turn:
		jp	process_turn
.bump:
		GET_GAME_VARIABLE $27
		jr	nz,.bump_beep
		inc	(iy+9)
		inc	(iy+$27)
		call	redraw_location
.bump_beep:
		GET_GAME_VARIABLE $10
		jr	nz,.bump_undo
		GET_GAME_VARIABLE $2E
		ret	nz
		ld	de,$32
		ld	hl,$15
		call	call_beeper
.bump_undo:
		GET_GAME_VARIABLE $09
		jr	z,process_turn
		dec	(iy+9)
		dec	(iy+$27)
		call	redraw_location
		jr	process_turn
