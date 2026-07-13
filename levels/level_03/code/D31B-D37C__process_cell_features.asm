; --- process_cell_features ($D31B-$D37C) -----------------------
; @done
; Run each of the 6 current-cell feature bits through its effect (masks via cell_feature_masks).

process_cell_features:
		ld	b,0			; b = feature slot 0..5
		ld	(iy+$3F),b
.loop:
		call	get_cell_feature
		push	bc
		ld	c,a
		GET_B_FROM_TABLE $03		; cell_feature_masks[slot]
		and	c
		jr	z,.next			; feature bit clear -> skip
		ld	a,b
		cp	2
		jr	nc,.feat2
		call	announce_stairs		; slot 0/1 = stairs
		jr	.next
.feat2:
		jr	nz,.feat3
		inc	(iy+$3F)		; slot 2
		ld	a,$7F
		call	mask_cell_byte
		jr	.next
.feat3:
		cp	3
		jr	nz,.feat4
		GET_GAME_VARIABLE $20		; slot 3 = trap (unless disarmed)
		jr	z,.spring
		GET_RND_NUMBERS
		and	3
		jr	nz,.next		; 3-in-4 the trap doesn't fire
.spring:
		ld	a,$EF
		call	mask_cell_byte
		call	trap_area_damage
		jp	.next
.feat4:
		cp	4
		jr	nz,dispatch_special_location	; slot 5 -> special-location dispatcher
		GET_GAME_VARIABLE $1F		; slot 4 = darkness
		jr	z,.dark
		xor	a
		ld	(iy+$1F),a
		ld	(iy+$27),a
		SHOW_ICON $09
.dark:
		xor	a
		call	set_state_and_redraw
		PRINT_MESSAGE2 $02		; "darkness!"
.next:
		pop	bc
		inc	b
		ld	a,b
		cp	6
		jr	nz,.loop
		ret
