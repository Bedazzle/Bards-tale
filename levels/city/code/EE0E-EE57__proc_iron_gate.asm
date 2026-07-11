; --- proc_iron_gate -------------------------------------------
; @done
; Location handler for the iron gate outside a wizard's tower. It
; names the tower's owner (Mangar for the northern coords, i.e.
; VAR_COORD_SO_NO < $0E, printed as word $76; Kylearan otherwise),
; then waits for a key. It scans the gate table (GATE_TABLE, four
; SO_NO/WE_EA/direction records) for the record matching the
; party's position; on a match it sets VAR_FACE_DIRECTION to the
; record's pass-through direction and steps the party through the
; gate (pass_through_gate). No match keeps scanning the table.
proc_iron_gate:
		SHOW_NAME_AND_PICTURE	6,PIC_TOWER		; Iron Gate

		CLEAR_INFO_PANEL

		PRINT2_IN_LOOP
		DB $21,$53,$FF			; You stand before
									; an iron gate, beyond which stands

		ld	a,(GAME_VARIABLES + VAR_COORD_SO_NO)

		cp	$0E
		jr	nc,.owner_kylearan	; high coords -> Kylearan's tower

		ld	a,$76 ; 'v'

		PRINT_WORD

		jr	.print_tower
; -------------------------------------

.owner_kylearan:
		PRINT_MESSAGE2	$22			; "Kylearan"

.print_tower:
		PRINT2_IN_LOOP
		DB $7A,$51,$FF			; "'s tower."
									; "Press a key to head back."

		WAIT_KEY_DOWN

		ld	hl,GATE_TABLE

.scan_gates:
		ld	a,(hl)
		inc	hl

		cp	(iy+VAR_COORD_SO_NO)
		jr	nz,.next_gate

		ld	a,(hl)
		cp	(iy+VAR_COORD_WE_EA)
		jr	z,.gate_matched

.next_gate:
		inc	hl
		inc	hl
		jr	.scan_gates
; -------------------------------------

.gate_matched:
		inc	hl
		ld	a,(hl)
		ld	(GAME_VARIABLES + VAR_FACE_DIRECTION),a
		jp	pass_through_gate

; -------------------------------------
		include "constants_gates.asm"
; -------------------------------------
