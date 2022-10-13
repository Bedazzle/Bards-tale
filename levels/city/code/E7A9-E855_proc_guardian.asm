proc_guardian:
		CLEAR_INFO_PANEL

		call	loc_E805

		GET_E_FROM_TABLE	INX_GUARDIANS

		ld      (___table_84), a

		GET_E_FROM_TABLE	10h

		cp      (iy+VAR_FACE_DIRECTION)
		jr      z, loc_E7E3

		SHOW_NAME_AND_PICTURE	7, PIC_GUARDIAN		; Guardian

		PRINT_MESSAGE2	23h					; "You can:"
											; ""
											; "(A)ttack it"
											; "(L)eave it and"
											; "head back."

loop_guardian:
		WAIT_KEY_DOWN

		cp	'L'
		jr	z, leave_guardian

		cp	'A'
		jr	nz, loop_guardian

attack_guardian:
		xor	a
		ld	(GAME_VARIABLES + VAR_4D), a
		ld	(GAME_VARIABLES + VAR_5A), a
		inc	a
		ld	(___table_85), a
		inc	(iy+VAR_5B)
		call	combat_foes

		GET_GAME_VARIABLE	VAR_51		; ???

		jr	nz, proc_guardian

loc_E7E3:
		ld	hl, (GAME_VARIABLES + VAR_COORD_SO_NO)
		ld	(GAME_VARIABLES + VAR_38), hl
		call	sub_F112
		and	7
		exx
		ld	(hl), a
		exx

		jr	loc_E800
; -------------------------------------

leave_guardian:
		ld	hl, GAME_VARIABLES + VAR_FACE_DIRECTION
		ld	a, (hl)
		push	af
		xor	2
		ld	(hl), a
		call	do_walk
		pop	af
		ld	(hl), a

loc_E800:
		CLEAR_INFO_PANEL

		jp	dyn_proc_81
; -------------------------------------

loc_E805:
		ld	e, 0
		ld	hl, GUARDIAN_COORDS		;0E86Ah

loc_E80A:
		ld	a, (GAME_VARIABLES + VAR_COORD_SO_NO)
		cp	(hl)
		inc	hl
		jr	nz, loc_E817

		ld	a, (GAME_VARIABLES + VAR_COORD_WE_EA)

		cp	(hl)
		jr	z, loc_E81E

loc_E817:
		inc	hl
		inc	e
		ld	a, e

		cp	0Ah
		jr	c, loc_E80A

loc_E81E:
		GET_E_FROM_TABLE	10h

		cp      (iy+VAR_FACE_DIRECTION)
		ret     z

		PRINT2_IN_LOOP
		db  21h, 52h,0FFh			; "You stand before"
									; "a gate, which is guarded by"

		xor	a
		ld	(GAME_VARIABLES + VAR_4F), a

		GET_E_FROM_TABLE	INX_GUARDIANS

         push    af

         cp      GUARD_GOLEM
		jr	z, guard_golem

		PRINT_MESSAGE2	8Bh			; "the statue of a"

		pop	af
		push	af

		cp	GUARD_OGRE_LORD
		jr	nz, loc_E843

		ld	a, 6Eh

		PRINT_WITH_CODES

loc_E843:
		PRINT_SPACE

		pop	af

		cp	GUARD_SAMURAI
		jr	nz, guard_other

guard_samurai:
		PRINT_MESSAGE2	8Ch			; "Samurai warrior"

		ret
; -------------------------------------

guard_other:
		PRINT_WORD

		ret
; -------------------------------------

guard_golem:
		pop	af

		PRINT_MESSAGE2	8Dh			; "a Stone Golem"

		ret
