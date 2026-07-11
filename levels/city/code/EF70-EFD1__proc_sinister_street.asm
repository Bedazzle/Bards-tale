; --- proc_sinistr_strt ----------------------------------------
; @done
; Per-step handler for the City's "Sinister Street". Beeps a
; footstep, then samples the map cell the party stands on. A plain
; (zero) cell walks the party and renders the 3D view; a nonzero
; cell dispatches to a special-tile handler through jump table $0A.
; Tile $0D is passable only if a hero has item $0F equipped; a hit
; on coord (2,$19) teleports the party to north-south row 7.
; Out: falls through into the wall/creature renderer (jp display_walls_creatures)
proc_sinistr_strt:
		call	step_beep
		ld	hl,(GAME_VARIABLES + VAR_COORD_SO_NO)
		ld	(GAME_VARIABLES + VAR_VIEW_Y_OFFSET),hl
		call	sample_view_cell
		jr	nz,check_barrier_tile

		FIND_INN	4

sinister_teleport:
		CLEAR_INFO_PANEL

		ld	a,(GAME_VARIABLES + VAR_FACE_DIRECTION)
		add	a,$BA
		ld	e,a
		call	show_you_are
		call	DO_SOME_MOVEMENT
		ld	hl,(GAME_VARIABLES + VAR_COORD_SO_NO)
		ld	a,l

		cp	2
		jr	nz,no_teleport

		ld	a,h

		cp	$19
		jr	nz,no_teleport

		ld	(iy+VAR_COORD_SO_NO),7	; throw party to another location

no_teleport:
		jp	display_walls_creatures
; -------------------------------------

check_barrier_tile:
		call	divide_A_by_8

		cp	$0D
		jr	nz,.dispatch

		ld	b,6

.check_hero:
		CHECK_EQUIPPED	$0F		; item $0F lets the party pass tile $0D

		jr	nc,sinister_teleport
		djnz	.check_hero

		ld	a,$0D

.dispatch:
		add	a,a
		ld	b,a

		GET_B_FROM_TABLE	$0A

		ld	l,a
		inc	b

		GET_B_FROM_TABLE	$0A

		ld	h,a

		jp	(hl)

; ======= S U B	R O U T	I N E =========

; --- step_beep -------------------------------------------------
; @done
; Click the beeper for a party footstep. Suppressed while a spell
; is active or the animation-speed flag is set (both leave the
; sound off and return early).
; Out: no beep if VAR_SPELL_ACTIVE or VAR_ANIM_SPEED_FLAG nonzero
; Note: tail-calls call_beeper (pitch 1, duration 2)
step_beep:
		GET_GAME_VARIABLE	VAR_SPELL_ACTIVE		; ???

		ret	nz

		GET_GAME_VARIABLE	VAR_ANIM_SPEED_FLAG		; ???

		ret	nz

		ld	de,2		; duration
		ld	hl,1		; pitch

		jp	call_beeper
