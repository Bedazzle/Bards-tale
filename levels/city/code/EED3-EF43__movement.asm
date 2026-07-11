; --- movement -------------------------------------------------
; @done
; City movement-key dispatcher. Reads the pending key
; (VAR_PRESSED_KEY) and branches: J = turn left, L = turn right,
; I = step forward, K = kick the obstacle ahead. Any other key
; returns without acting. hl is preloaded to VAR_FACE_DIRECTION
; for the turn handlers.
; Note: forward/kick consult VIEW_NEAR_CENTRE (the obstacle code in front)
;       to choose walk vs a "bump" beep vs a kick.
movement:
		ld	a,(GAME_VARIABLES + VAR_PRESSED_KEY)
		ld	hl,GAME_VARIABLES + VAR_FACE_DIRECTION

		cp	'J'
		jr	z,turn_left

		cp	'L'
		jr	z,turn_right

		cp	'K'
		jr	z,kick_door

		cp	'I'
		jr	z,move_forward

		ret
; -------------------------------------

move_forward:
		ld	a,(VIEW_NEAR_CENTRE)
		and	7
		jr	z,walk_forward		; path ahead clear -> just walk

		GET_GAME_VARIABLE	VAR_SPELL_ACTIVE		; ???

		ret	nz

		GET_GAME_VARIABLE	VAR_ANIM_SPEED_FLAG		; ???

		ret	nz

		ld	de,$32			; duration
		ld	hl,$15			; pitch

		jp	call_beeper
; -------------------------------------

kick_door:
		ld	a,(VIEW_NEAR_CENTRE)
		or	a
		jr	z,walk_forward		; nothing to kick -> just walk

		push	af
		call	do_walk
		pop	af

		jp	check_barrier_tile
; -------------------------------------

turn_left:
		dec	(hl)
		jp	p,move_execute

		ld	(hl),3

		jr	move_execute
; -------------------------------------

turn_right:
		inc	(hl)
		ld	a,(hl)
		sub	4

		jr	nz,move_execute

		ld	(hl),a

move_execute:
		call	show_compass
		jp	dispatch_movement
; -------------------------------------

; --- do_walk --------------------------------------------------
; @done
; Advance the party one square in the current facing direction:
; reads VAR_FACE_DIRECTION (0=N,1=E,2=S,3=W) and inc/decrements the
; SO_NO / WE_EA map coordinate accordingly.
; In:  hl -> VAR_FACE_DIRECTION, iy = GAME_VARIABLES base
; Note: also called from proc_gate_closed and proc_guardian.
do_walk:
		ld	a,(hl)
		or	a
		jr	z,go_north

		dec	a
		jr	z,go_east

		dec	a
		jr	z,go_south

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

walk_forward:
		call	do_walk
		jr	move_execute
