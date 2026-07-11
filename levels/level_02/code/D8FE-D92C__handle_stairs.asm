; --- handle_stairs -----------------------------------------
; @done
; Stairs feature (cell feature bits 0/1). If the active hero can act, print
; "there are stairs here, going up/down. Do you wish to take them? [Y-N]" and, on Y,
; take them (jump into the move handler); otherwise return.
handle_stairs:
		GET_ATTR_SAVE_IX $3d
		ret	nz
		inc	(hl)
		CLEAR_INFO_PANEL
		PRINT_MESSAGE2 $00		; "there are stairs "
		PRINT_MESSAGE2 $26		; "here, going "
		ld	a,(var_FA55)
		xor	b
		and	1
		jr	z,.up
		PRINT_MESSAGE2 $31		; "down"
		jr	.ask

.up:
		PRINT_MESSAGE2 $30		; "up"
.ask:
		PRINT_MESSAGE2 $01		; " Do you wish to take them? [Y-N]"
		rst	$10 : db $2C		; yes/no prompt (unnamed dispatch)
		jp	nc,clear_info_panl
		CLEAR_INFO_PANEL
		ld	a,b
		or	a
		jp	z,stairs_down
		jp	stairs_up
