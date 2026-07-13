; --- announce_stairs ($DA30-$DA5E) -----------------------------
; @done
; Announce stairs at the cell: print 'there are stairs '+'here, going '+up/down.
; Prints 'there are stairs here, going up/down' for the current cell

announce_stairs:
		GET_ATTR_SAVE_IX $3D
		ret	nz			; not a stairs cell
		inc	(hl)
		CLEAR_INFO_PANEL
		PRINT_MESSAGE2 $00		; "there are stairs "
		PRINT_MESSAGE2 $2E		; "here, going "
		ld	a,(special_loc_list+$15)
		xor	b
		and	1			; parity -> up or down
		jr	z,.stairs_up
		PRINT_MESSAGE2 $39		; "down"
		jr	.ask_take
.stairs_up:
		PRINT_MESSAGE2 $38		; "up"
.ask_take:
		PRINT_MESSAGE2 $01		; " Do you wish to take them? [Y-N]"
		rst	$10 : db $2C		; read Y/N -> carry
		jp	nc,clear_info_panl	; N: just close the panel

		CLEAR_INFO_PANEL
		ld	a,b
		or	a
		jp	z,handle_move_key.stairs_up	; take up
		jp	handle_move_key.stairs_down	; take down
