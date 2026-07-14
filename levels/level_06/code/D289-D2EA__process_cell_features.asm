; --- process_cell_features ($D289-$D2EA) ----------------------------------
; @done
; Run each of the 6 current-cell feature bits through its effect (masks via cell_feature_masks).

process_cell_features:
		ld	b,0
		ld	(iy+$3F),b
.loop:
		call	get_cell_feature
		push	bc
		ld	c,a
		GET_B_FROM_TABLE $03
		and	c
		jr	z,.done
		ld	a,b
		cp	2
		jr	nc,.skip
		call	announce_stairs
		jr	.done
.skip:
		jr	nz,.skip2
		inc	(iy+$3F)
		ld	a,$7F
		call	mask_cell_byte
		jr	.done
.skip2:
		cp	3
		jr	nz,.skip4
		GET_GAME_VARIABLE $20
		jr	z,.skip3
		GET_RND_NUMBERS
		and	3
		jr	nz,.done
.skip3:
		ld	a,$EF
		call	mask_cell_byte
		call	trap_area_damage
		jp	.done
.skip4:
		cp	4
		jr	nz,mask_cell_byte.skip
		GET_GAME_VARIABLE $1F
		jr	z,.skip5
		xor	a
		ld	(iy+$1F),a
		ld	(iy+$27),a
		SHOW_ICON $09
.skip5:
		xor	a
		call	set_state_and_redraw
		PRINT_MESSAGE2 $02
.done:
		pop	bc
		inc	b
		ld	a,b
		cp	6
		jr	nz,.loop
		ret
