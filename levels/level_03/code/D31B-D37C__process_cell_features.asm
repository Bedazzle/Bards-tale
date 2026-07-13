; --- process_cell_features ($D31B-$D37C) -----------------------
; @wip
; Run each of the 6 current-cell feature bits through its effect (masks via cell_feature_masks).

process_cell_features:
		ld	b,0
		ld	(iy+$3f),b
.d320:
		call	get_cell_feature
		push	bc
		ld	c,a
		GET_B_FROM_TABLE $03
		and	c
		jr	z,.d375
		ld	a,b
		cp	2
		jr	nc,.d335
		call	announce_stairs
		jr	.d375
.d335:
		jr	nz,.d341
		inc	(iy+$3f)
		ld	a,$7f
		call	mask_cell_byte
		jr	.d375
.d341:
		cp	3
		jr	nz,.d35b
		GET_GAME_VARIABLE $20
		jr	z,.d350
		GET_RND_NUMBERS
		and	3
		jr	nz,.d375
.d350:
		ld	a,$ef
		call	mask_cell_byte
		call	trap_area_damage
		jp	.d375
.d35b:
		cp	4
		jr	nz,dispatch_special_location
		GET_GAME_VARIABLE $1f
		jr	z,.d36e
		xor	a
		ld	(iy+$1f),a
		ld	(iy+$27),a
		SHOW_ICON $09
.d36e:
		xor	a
		call	set_state_and_redraw
		PRINT_MESSAGE2 $02
.d375:
		pop	bc
		inc	b
		ld	a,b
		cp	6
		jr	nz,.d320
		ret
