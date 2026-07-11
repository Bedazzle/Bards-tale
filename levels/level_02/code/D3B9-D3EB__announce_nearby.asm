; --- announce_nearby ---------------------------------------
; @done
; If sensing is active (game var $22), scan the cells ahead and announce what is
; sensed from the scan flags returned in E by scan_cells_ahead, gated by the sense
; level ($6004): stairs, "something special near", "trap near".
announce_nearby:
		GET_GAME_VARIABLE $22
		ret	z
		ld	(iy+$35),0
		call	scan_cells_ahead
		ret	z
		CLEAR_INFO_PANEL
		ld	a,(var_6004)
		srl	e
		jr	nc,.chk_special
		or	a
		jr	z,.chk_special
		PRINT_MESSAGE2 $00		; "there are stairs"
		PRINT_MESSAGE2 $27		; "near here..."
.chk_special:
		srl	e
		jr	nc,.chk_trap
		cp	2
		jr	nz,.chk_trap
		PRINT_MESSAGE2 $04		; "Something special is near..."
.chk_trap:
		srl	e
		ret	nc
		cp	1
		ret	z
		PRINT_MESSAGE2 $05		; "There is a trap near!"
		ret
