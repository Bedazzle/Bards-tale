; --- proc_teleport ------------------------------------------
; @done
; The dungeon "Teleport" action. Only works underground and outside
; combat (round 0). Prompts the player to build a destination with
; the arrow keys - adjusting the N-S coord, the W-E coord and the
; dungeon level (each via adjust_value_updown) - then asks "Abort?".
; If confirmed and the target dungeon level is a valid teleport
; destination (validated against TELEPORT_MAP, ADDR_TABLE slot $58, at
; sub-index d and d+8), it moves the party there; when the level
; changes it reloads the level tape via insert_skara_tape.
; In:  iy = game variables
; Note: above ground or in combat it just prints "..." and returns.
proc_teleport:

		GET_GAME_VARIABLE	VAR_UNDERGROUND

		jr	z,wait_teleport.no_teleport

		GET_GAME_VARIABLE	VAR_ROUND_NUMBER		; ???

		jr	nz,wait_teleport.no_teleport

		CLEAR_INFO_PANEL

		PRINT_MESSAGE	$24			; "Teleport [Use arrow keys and SPC to select]"

		ld	a,(CITY_MAP_DATA+$026E)
		or	a
		jr	z,show_down

show_up:
		PRINT_MESSAGE	$26			; "Up   : +"

		jr	wait_teleport

show_down:
		PRINT_MESSAGE	$25			; "Down : +"

wait_teleport:
		ld	(iy+VAR_CURSOR_ROW),7
		ld	a,(GAME_VARIABLES + VAR_COORD_SO_NO)

		ADJUST_VALUE

		ld	c,a
		ld	a,(GAME_VARIABLES + VAR_COORD_WE_EA)

		ADJUST_VALUE

		ld	b,a
		ld	a,(GAME_VARIABLES + VAR_TELEPORT_MODE)

		ADJUST_VALUE

		ld	d,a

		PRINT_CRLF_AND_MESSAGE	$27			; "Abort?"

		PRINT_YES_NO_WAIT

		jr	c,.abort

		bit	7,d
		jr	nz,.abort

		GET_D_FROM_TABLE	$58

		jr	c,.abort

		ld	a,d
		add	a,8

		GET_A_FROM_TABLE	$58

		jr	c,.abort

		ld	(GAME_VARIABLES + VAR_COORD_SO_NO),bc
		ld	a,d
		ld	hl,GAME_VARIABLES + VAR_TELEPORT_MODE

		cp	(hl)
		jr	z,.same_level

		ld	(hl),d

		jp	teleport_to_level
; -------------------------------------

.no_teleport:
		jp	print_ellipsis
; -------------------------------------

.same_level:
		call	hook_street_step
		xor	a
		ld	(GAME_VARIABLES + VAR_SAVE_STATE_HI),a

.abort:
		and	a			; clear carry = teleport handled / cancelled

		ret
; -------------------------------------

teleport_to_level:
		GET_IY_A_FROM_TABLE	$3B,$58

		add	a,4
		ld	c,a
		ld	b,$FF

		jp	insert_skara_tape
