; --- proc_gate_closed -----------------------------------------
; @done
; Location handler for the snow-blocked city gate. Shows the "gates
; blocked by a gigantic snow drift" message, waits for a key, then
; falls through to process_exit to turn the party around and leave.
proc_gate_closed:
		FIND_INN	$0E

		CLEAR_INFO_PANEL

		PRINT2_IN_LOOP
		DB $21,$50,$51,$FF			; "You stand before"
										; "the city gates, which are blocked by a gigantic snow drift."
										; "Press a key to head back."

		WAIT_KEY_DOWN

; --- process_exit ---------------------------------------------
; @done
; Shared "leave this location" tail used by most city handlers.
; Turns the party 180 degrees (flips VAR_FACE_DIRECTION bit 1),
; then falls into pass_through_gate to walk one step out, redraw the
; compass and hand control back to the movement loop (dispatch_movement).
; Note: pass_through_gate is also entered directly by proc_iron_gate.
process_exit:
		CLEAR_INFO_PANEL

		ld	hl,GAME_VARIABLES + VAR_FACE_DIRECTION
		ld	a,(hl)
		xor	2
		ld	(hl),a

pass_through_gate:
		call	show_compass
		call	do_walk

		jp	dispatch_movement
