; --- handle_move_key ($DC19-$DCF7) -----------------------------
; @wip
; Dispatch[0]: read the movement/action key and act (move/turn/etc.).

handle_move_key:
		ld	a,(iy+$24)
		cp	$4c
		jr	z,.dc8d
		cp	$4b
		jr	z,.dca0
		cp	$4a
		jr	z,.dc82
		cp	$49
		jp	z,.dcb5
		cp	$44
		jp	z,.dc4b
		cp	$45
		ret	nz
		call	get_cell_feature
		and	$40
		jp	z,.dcc5
		GET_GAME_VARIABLE $20
		jp	z,.dcc5
		ld	a,($fa55)
		or	a
		jr	nz,.dc60
		jr	.dc66
.dc4b:
		call	get_cell_feature
		and	$20
		jr	z,.dcc5
		GET_GAME_VARIABLE $20
		jr	nz,.dc5a
		call	damage_all_groups
.dc5a:
		ld	a,($fa55)
		or	a
		jr	nz,.dc66
.dc60:
		inc	(iy+$3b)
		jp	teleport_to_level
.dc66:
		dec	(iy+$3b)
		jp	p,teleport_to_level
		ld	hl,($fa53)
		ld	(var_5FAC),hl
		ld	a,($fa5f)
		ld	(var_5FAE),a
		xor	a
		ld	(var_5FE6),a
		ld	c,a
		ld	b,$ff
		jp	insert_skara_tape
.dc82:
		ld	a,(iy+3)
		dec	a
		jp	p,.dc96
		ld	a,3
		jr	.dc96
.dc8d:
		ld	a,(iy+3)
		inc	a
		cp	4
		jr	nz,.dc96
		xor	a
.dc96:
		ld	(iy+3),a
		ld	(iy+$40),0
		jp	process_turn
.dca0:
		ld	a,(SPELL_SECRET_STATE)
		or	a
		jr	z,.dcbb
		cp	2
		jr	nz,.dcaf
.dcaa:
		call	move_beep
		jr	.dcbb
.dcaf:
		cp	3
		jr	nz,.dcc8
		jr	.dcaa
.dcb5:
		ld	a,(SPELL_SECRET_STATE)
		or	a
		jr	nz,.dcc3
.dcbb:
		GET_GAME_VARIABLE $3e
		jr	nz,.dcc8
		call	move_party_forward
.dcc3:
		CLEAR_INFO_PANEL
.dcc5:
		jp	process_turn
.dcc8:
		GET_GAME_VARIABLE $27
		jr	nz,.dcd6
		inc	(iy+9)
		inc	(iy+$27)
		call	redraw_location
.dcd6:
		GET_GAME_VARIABLE $10
		jr	nz,.dce8
		GET_GAME_VARIABLE $2e
		ret	nz
		ld	de,$32
		ld	hl,$15
		call	call_beeper
.dce8:
		GET_GAME_VARIABLE $09
		jr	z,process_turn
		dec	(iy+9)
		dec	(iy+$27)
		call	redraw_location
		jr	process_turn
