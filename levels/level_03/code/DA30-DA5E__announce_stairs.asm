; --- announce_stairs ($DA30-$DA5E) -----------------------------
; @wip
; Announce stairs at the cell: print 'there are stairs '+'here, going '+up/down.

announce_stairs:
		GET_ATTR_SAVE_IX $3d
		ret	nz
		inc	(hl)
		CLEAR_INFO_PANEL
		PRINT_MESSAGE2 $00
		PRINT_MESSAGE2 $2e
		ld	a,($fa55)
		xor	b
		and	1
		jr	z,.da4a
		PRINT_MESSAGE2 $39
		jr	.da4d
.da4a:
		PRINT_MESSAGE2 $38
.da4d:
		PRINT_MESSAGE2 $01
		rst	$10 : db $2c
		jp	nc,clear_info_panl
		CLEAR_INFO_PANEL
		ld	a,b
		or	a
		jp	z,handle_move_key.dc66
		jp	handle_move_key.dc60
