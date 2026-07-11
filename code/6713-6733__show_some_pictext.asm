; --- show_some_pictext ----------------------------------------
; @done
; Refresh the encounter picture and caption. Clears the text buffer; if
; there are no monster groups it shows the default party picture,
; otherwise it picks the lead monster's image (INX_MONST_IMAGE) and
; shows it. Finishes by printing the location name.
; In:  iy = game variables base
show_some_pictext:
		CLEAR_TXT_BUFFER

		IF_FB98_IS_ZERO

		jr	nz,.show_monster

		ld	a,$91 ; '‘'

		PRINT_EMPTY

		ld	a,1

		jr	show_pic

.show_monster:
		dec	a
		ld	(GAME_VARIABLES + VAR_DISPLAY_COUNT),a
		ld	a,(ACTIVE_GUARDIAN)
		push	af

		PRINT_EMPTY

		pop	af

		GET_A_FROM_TABLE	INX_MONST_IMAGE

show_pic:
		SHOW_PIC_BY_A

		jp	print_loc_name
