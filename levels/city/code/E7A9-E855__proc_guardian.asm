; --- proc_guardian ------------------------------------------
; @done
; Handler for reaching a guardian-protected gate. Identifies the
; guardian at the party's position (describe_guardian) and records it
; in ACTIVE_GUARDIAN. If the party is not facing this guardian's gate
; it passes straight through; otherwise it offers (A)ttack or (L)eave.
; Attack runs combat_foes and, on victory, passes the gate; Leave
; turns the party around and walks back.
; In:  iy = game variables base
proc_guardian:
		CLEAR_INFO_PANEL

		call	describe_guardian

		GET_E_FROM_TABLE	INX_GUARDIANS

		ld      (ACTIVE_GUARDIAN),a

		GET_E_FROM_TABLE	$10

		cp      (iy+VAR_FACE_DIRECTION)
		jr      z,pass_gate

		SHOW_NAME_AND_PICTURE	7,PIC_GUARDIAN		; Guardian

		PRINT_MESSAGE2	$23					; "You can:"
											; ""
											; "(A)ttack it"
											; "(L)eave it and"
											; "head back."

loop_guardian:
		WAIT_KEY_DOWN

		cp	'L'
		jr	z,leave_guardian

		cp	'A'
		jr	nz,loop_guardian

attack_guardian:
		xor	a
		ld	(GAME_VARIABLES + VAR_ENEMY_COUNT),a
		ld	(GAME_VARIABLES + VAR_AMBUSH_FLAG),a
		inc	a
		ld	(COMBAT_ACTIVE_FLAG),a
		inc	(iy+VAR_ENCOUNTER_CTR)
		call	combat_foes

		GET_GAME_VARIABLE	VAR_FLEE_SUCCESS		; ???

		jr	nz,proc_guardian

pass_gate:
		ld	hl,(GAME_VARIABLES + VAR_COORD_SO_NO)
		ld	(GAME_VARIABLES + VAR_VIEW_Y_OFFSET),hl
		call	sample_view_cell
		and	7
		exx
		ld	(hl),a
		exx

		jr	guardian_exit
; -------------------------------------

leave_guardian:
		ld	hl,GAME_VARIABLES + VAR_FACE_DIRECTION
		ld	a,(hl)
		push	af
		xor	2
		ld	(hl),a
		call	do_walk
		pop	af
		ld	(hl),a

guardian_exit:
		CLEAR_INFO_PANEL

		jp	dispatch_movement
; -------------------------------------

; --- describe_guardian --------------------------------------
; @done
; Find the guardian standing at the party's current map position by
; scanning the GUARDIAN_COORDS table (up to 10 entries). If the party
; faces that guardian's gate, print "You stand before a gate, guarded
; by <name>" (special-casing the Ogre Lord's title, the Samurai, and
; the Stone Golem). Returns without printing if the party is not
; facing the gate.
; In:  iy = game variables base
; Out: e = index of the matched guardian (used by the caller to fetch
;      its type/id from the guardian tables)
describe_guardian:
		ld	e,0
		ld	hl,GUARDIAN_COORDS		;0E86Ah

.scan:
		ld	a,(GAME_VARIABLES + VAR_COORD_SO_NO)
		cp	(hl)
		inc	hl
		jr	nz,.next

		ld	a,(GAME_VARIABLES + VAR_COORD_WE_EA)

		cp	(hl)
		jr	z,.matched

.next:
		inc	hl
		inc	e
		ld	a,e

		cp	$0A
		jr	c,.scan

.matched:
		GET_E_FROM_TABLE	$10

		cp      (iy+VAR_FACE_DIRECTION)
		ret     z

		PRINT2_IN_LOOP
		DB $21,$52,$FF			; "You stand before"
									; "a gate, which is guarded by"

		xor	a
		ld	(GAME_VARIABLES + VAR_DISPLAY_COUNT),a

		GET_E_FROM_TABLE	INX_GUARDIANS

         push    af

         cp      GUARD_GOLEM
		jr	z,guard_golem

		PRINT_MESSAGE2	$8B			; "the statue of a"

		pop	af
		push	af

		cp	GUARD_OGRE_LORD
		jr	nz,.print_name

		ld	a,$6E

		PRINT_WITH_CODES

.print_name:
		PRINT_SPACE

		pop	af

		cp	GUARD_SAMURAI
		jr	nz,guard_other

guard_samurai:
		PRINT_MESSAGE2	$8C			; "Samurai warrior"

		ret
; -------------------------------------

guard_other:
		PRINT_WORD

		ret
; -------------------------------------

guard_golem:
		pop	af

		PRINT_MESSAGE2	$8D			; "a Stone Golem"

		ret
