; --- announce_nearby ($D4EB-$D51D) -----------------------------
; @wip
; After a move, sense and announce nearby special locations / traps.

announce_nearby:
		GET_GAME_VARIABLE $22
		ret	z
		ld	(iy+$35),0
		call	scan_cells_ahead
		ret	z
		CLEAR_INFO_PANEL
		ld	a,(var_6004)
		srl	e
		jr	nc,.d509
		or	a
		jr	z,.d509
		PRINT_MESSAGE2 $00
		PRINT_MESSAGE2 $2f
.d509:
		srl	e
		jr	nc,.d514
		cp	2
		jr	nz,.d514
		PRINT_MESSAGE2 $04
.d514:
		srl	e
		ret	nc
		cp	1
		ret	z
		PRINT_MESSAGE2 $05
		ret
