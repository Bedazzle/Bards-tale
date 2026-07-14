; --- announce_stairs ($D91F-$D94D) ----------------------------------
; @done
; Announce stairs at the cell: print 'there are stairs '+'here, going '+up/down.
; Prints 'there are stairs here, going up/down' for the current cell

announce_stairs:
		GET_ATTR_SAVE_IX $3D
		ret	nz
		inc	(hl)
		CLEAR_INFO_PANEL
		PRINT_MESSAGE2 $00
		PRINT_MESSAGE2 $26
		ld	a,($FA55)
		xor	b
		and	1
		jr	z,.skip
		PRINT_MESSAGE2 $31
		jr	.skip2
.skip:
		PRINT_MESSAGE2 $30
.skip2:
		PRINT_MESSAGE2 $01
		rst	$10 : db $2C
		jp	nc,clear_info_panl
		CLEAR_INFO_PANEL
		ld	a,b
		or	a
		jp	z,handle_move_key.skip4
		jp	handle_move_key.skip3
