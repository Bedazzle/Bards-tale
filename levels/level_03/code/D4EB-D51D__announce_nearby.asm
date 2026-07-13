; --- announce_nearby ($D4EB-$D51D) -----------------------------
; @done
; After a move, sense and announce nearby special locations / traps.

announce_nearby:
		GET_GAME_VARIABLE $22
		ret	z			; sensing not active
		ld	(iy+$35),0
		call	scan_cells_ahead
		ret	z			; nothing sensed
		CLEAR_INFO_PANEL
		ld	a,(speed_lookup)
		srl	e			; bit 0 = stairs ahead
		jr	nc,.check_special
		or	a
		jr	z,.check_special
		PRINT_MESSAGE2 $00		; "there are stairs "
		PRINT_MESSAGE2 $2F		; "near here..."
.check_special:
		srl	e			; bit 1 = something special
		jr	nc,.check_trap
		cp	2
		jr	nz,.check_trap
		PRINT_MESSAGE2 $04		; " \rSomething special is near..."
.check_trap:
		srl	e			; bit 2 = trap
		ret	nc
		cp	1
		ret	z
		PRINT_MESSAGE2 $05		; " \rThere is a trap near!"
		ret
