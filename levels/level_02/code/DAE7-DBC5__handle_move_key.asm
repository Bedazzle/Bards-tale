; --- handle_move_key ---------------------------------------
; @done
; Dispatch[0]: act on the pressed key (iy+$24): I=forward, J=turn left, K=action,
; L=turn right, D=kick/down, E=up. Stairs targets stairs_up/stairs_down (the latter
; loads the new level position and pulls the next level via insert_skara_tape) are
; also entered from handle_stairs. Ends by jumping to process_turn.
handle_move_key:
		ld	a,(iy+$24)
		cp	$4c
		jr	z,mk_turn_right
		cp	$4b
		jr	z,mk_key_k
		cp	$4a
		jr	z,mk_turn_left
		cp	$49
		jp	z,mk_forward
		cp	$44
		jp	z,mk_kick
		cp	$45
		ret	nz
		call	cellars_handlers
		and	$40
		jp	z,mk_end
		GET_GAME_VARIABLE $20
		jp	z,mk_end
		ld	a,(var_FA55)
		or	a
		jr	nz,stairs_up
		jr	stairs_down
mk_kick:
		call	cellars_handlers
		and	$20
		jr	z,mk_end
		GET_GAME_VARIABLE $20
		jr	nz,mk_kick_no_msg
		call	show_party_stats
mk_kick_no_msg:
		ld	a,(var_FA55)
		or	a
		jr	nz,stairs_down
stairs_up:
		inc	(iy+$3b)
		jp	teleport_to_level
stairs_down:
		dec	(iy+$3b)
		jp	p,teleport_to_level
		ld	hl,($fa53)
		ld	(coord_ns),hl
		ld	a,($fa5f)
		ld	(facing),a
		xor	a
		ld	(teleport_mode),a
		ld	c,a
		ld	b,$ff
		jp	insert_skara_tape
mk_turn_left:
		ld	a,(iy+3)
		dec	a
		jp	p,mk_set_facing
		ld	a,3
		jr	mk_set_facing
mk_turn_right:
		ld	a,(iy+3)
		inc	a
		cp	4
		jr	nz,mk_set_facing
		xor	a
mk_set_facing:
		ld	(iy+3),a
		ld	(iy+$40),0
		jp	process_turn
mk_key_k:
		ld	a,(SPELL_SECRET_STATE)
		or	a
		jr	z,mk_step
		cp	2
		jr	nz,mk_k_check
mk_k_act:
		call	trap_precheck
		jr	mk_step
mk_k_check:
		cp	3
		jr	nz,mk_regen
		jr	mk_k_act
mk_forward:
		ld	a,(SPELL_SECRET_STATE)
		or	a
		jr	nz,mk_clear
mk_step:
		GET_GAME_VARIABLE $3e
		jr	nz,mk_regen
		call	move_party_forward
mk_clear:
		CLEAR_INFO_PANEL
mk_end:
		jp	process_turn
mk_regen:
		GET_GAME_VARIABLE $27
		jr	nz,mk_beeper
		inc	(iy+9)
		inc	(iy+$27)
		call	render_dungeon_view
mk_beeper:
		GET_GAME_VARIABLE $10
		jr	nz,mk_regen2
		GET_GAME_VARIABLE $2e
		ret	nz
		ld	de,$32
		ld	hl,$15
		call	call_beeper
mk_regen2:
		GET_GAME_VARIABLE $09
		jr	z,process_turn
		dec	(iy+9)
		dec	(iy+$27)
		call	render_dungeon_view
		jr	process_turn

