; --- announce_nearby ($D459-$D48B) ----------------------------------
; @done
; After a move, sense and announce nearby special locations / traps.

announce_nearby:
		GET_GAME_VARIABLE $22
		ret	z
		ld	(iy+$35),0
		call	scan_cells_ahead
		ret	z
		CLEAR_INFO_PANEL
		ld	a,(speed_lookup)
		srl	e
		jr	nc,.skip
		or	a
		jr	z,.skip
		PRINT_MESSAGE2 $00
		PRINT_MESSAGE2 $28
.skip:
		srl	e
		jr	nc,.done
		cp	2
		jr	nz,.done
		PRINT_MESSAGE2 $04
.done:
		srl	e
		ret	nc
		cp	1
		ret	z
		PRINT_MESSAGE2 $05
		ret
