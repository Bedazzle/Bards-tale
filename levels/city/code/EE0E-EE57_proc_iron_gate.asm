proc_iron_gate:
		SHOW_NAME_AND_PICTURE	6, PIC_TOWER		; Iron Gate

		CLEAR_INFO_PANEL

		PRINT2_IN_LOOP
		db  21h, 53h,0FFh			; You stand before
									; an iron gate, beyond which stands

		ld	a, (GAME_VARIABLES + VAR_COORD_SO_NO)

		cp	0Eh
		jr	nc, loc_EE26

		ld	a, 76h ; 'v'

		PRINT_WORD

		jr	loc_EE29
; -------------------------------------

loc_EE26:
		PRINT_MESSAGE2	22h			; "Kylearan"

loc_EE29:
		PRINT2_IN_LOOP
		db  7Ah, 51h,0FFh			; "'s tower."
									; "Press a key to head back."

		WAIT_KEY_DOWN

		ld	hl, addr_EE4C

loc_EE33:
		ld	a, (hl)
		inc	hl

		cp	(iy+VAR_COORD_SO_NO)
		jr	nz, loc_EE40

		ld	a, (hl)
		cp	(iy+VAR_COORD_WE_EA)
		jr	z, loc_EE44

loc_EE40:
		inc	hl
		inc	hl
		jr	loc_EE33
; -------------------------------------

loc_EE44:
		inc	hl
		ld	a, (hl)
		ld	(GAME_VARIABLES + VAR_FACE_DIRECTION), a
		jp	loc_EECA

; -------------------------------------
		include "constants_gates.asm"
; -------------------------------------
