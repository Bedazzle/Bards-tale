; --- dispatch_special_location -----------------------------
; @done
; The dungeon's per-cell SPECIAL-EVENT dispatcher. For each special_dispatch_table
; record (base-4 indexed, N=1..10) it walks the location list at $FA40+param for the
; party's cell (iy+1/iy+2); on a match it patches the SMC jump (.dispatch_op) with the
; record's handler and jumps to that event case (ev_*, below). Each event case ends at
; dispatch_done -> process_cell_features.next.
; Note: two SMC slots (.dispatch jp, .portal call) patched via .dispatch_op / .portal_op.
dispatch_special_location:
		ld	b,1
.scan_loop:
		push	bc
		ld	hl,special_dispatch_table-4
.skip_record:
		inc	hl
		inc	hl
		inc	hl
		inc	hl
		djnz	.skip_record
		ld	b,(hl)
		inc	hl
		ld	c,(hl)
		inc	hl
		ld	e,(hl)
		inc	hl
		ld	d,(hl)
		ld	(.dispatch_op),de	; set SMC jump target
		ld	hl,special_loc_list
		ld	e,c
		ld	d,0
		add	hl,de
.match_loop:
		ld	a,(hl)
		inc	hl
		cp	(iy+1)
		jr	nz,.next_entry
		ld	a,(hl)
		cp	(iy+2)
		jr	nz,.next_entry
		pop	bc
.dispatch:
		jp	.dispatch		; operand patched below
.dispatch_op EQU $-2
.next_entry:
		inc	hl
		djnz	.match_loop
		pop	bc
		inc	b
		ld	a,b
		cp	11
		jr	c,.scan_loop
		jr	process_cell_features.next
ev_spin_facing:
		GET_RND_NUMBERS
		and	3
		ld	(iy+3),a
		call	show_compass
		call	render_dungeon_view
dispatch_done:
		jp	process_cell_features.next
ev_message:
		ld	a,1
		call	redraw_after_event
		PRINT_MESSAGE2 $03
		jr	dispatch_done
ev_guardian:
		ld	de,15
		add	hl,de
		ld	a,(hl)
		ld	(ACTIVE_GUARDIAN),a
		inc	hl
		ld	a,(hl)
		ld	(COMBAT_ACTIVE_FLAG),a
		ld	(iy+$4d),0
		inc	(iy+$5b)
		inc	(iy+$3f)
		ld	a,$fb
		call	mask_cell_byte
		jr	dispatch_done
ev_redraw_status:
		call	show_party_stats
		jr	dispatch_done
ev_inc_2f:
		inc	(iy+$2f)
		jr	dispatch_done
ev_inc_3e:
		inc	(iy+$3e)
		jr	dispatch_done
ev_show_locnum:
		ld	de,$fb20
		and	a
		sbc	hl,de
		ld	a,l
		srl	a
		add	a,$22
		push	af
		CLEAR_INFO_PANEL
		pop	af
		PRINT2_A_WITH_FLAG_0
		jr	dispatch_done
ev_portal:
		ld	de,15
		add	hl,de
		ld	e,(hl)
		inc	hl
		ld	d,(hl)
		ld	(.portal_op),de	; set SMC call target
.portal:
		call	.portal		; operand patched below
.portal_op EQU $-2
		GET_GAME_VARIABLE $3d
		jr	nz,dispatch_done
		call	render_dungeon_view
		jr	dispatch_done
ev_set_flags:
		ld	hl,var_5FCE
		ld	b,4
.flag_loop:
		ld	a,(hl)
		or	a
		jr	z,.flag_skip
		ld	(hl),1
.flag_skip:
		dec	hl
		djnz	.flag_loop
		ld	(iy+4),1
dispatch_done2:
		jp	dispatch_done
ev_teleport:
		ld	de,15
		add	hl,de
		ld	a,(hl)
		ld	(iy+1),a
		inc	hl
		ld	a,(hl)
		ld	(iy+2),a
		GET_GAME_VARIABLE $27
		jr	nz,.redraw
		inc	(iy+$27)
		call	render_dungeon_view
		dec	(iy+$27)
.redraw:
		call	render_dungeon_view
		jr	dispatch_done2
