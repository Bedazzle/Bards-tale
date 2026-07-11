; --- process_cell_features ---------------------------------
; @done
; For the party's current maze cell, test each of the 6 feature bits against
; cell_feature_masks and run that feature's effect: features 0/1 -> handle_stairs,
; feature 2 ($80) clears the bit, feature 3 ($10) reveal-gated special (spring_trap),
; feature 4 ($08) sets an icon + prints a message, feature 5 falls into the
; per-location dispatcher.
; In:  ($5FAC/$5FAD) = party cell.  Uses get_cell_feature / mask_cell_byte.
process_cell_features:
		ld	b,0
		ld	(iy+$3F),b
.loop:
		call	get_cell_feature
		push	bc
		ld	c,a
		GET_B_FROM_TABLE $03		; b = cell_feature_masks[b]
		and	c			; feature bit set for this cell?
		jr	z,.next
		ld	a,b
		cp	2
		jr	nc,.feat2
		call	handle_stairs		; features 0/1
		jr	.next

.feat2:
		jr	nz,.feat3
		inc	(iy+$3F)
		ld	a,$7F			; clear feature bit $80
		call	mask_cell_byte
		jr	.next

.feat3:
		cp	3
		jr	nz,.feat4
		GET_GAME_VARIABLE $20
		jr	z,.reveal
		GET_RND_NUMBERS
		and	3
		jr	nz,.next
.reveal:
		ld	a,$EF			; clear feature bit $10
		call	mask_cell_byte
		call	spring_trap
		jp	.next

.feat4:
		cp	4
		jr	nz,dispatch_special_location	; feature 5
		GET_GAME_VARIABLE $1F
		jr	z,.msg
		xor	a
		ld	(iy+$1F),a
		ld	(iy+$27),a
		SHOW_ICON $09
.msg:
		xor	a
		call	redraw_after_event
		PRINT_MESSAGE2 $02
.next:
		pop	bc
		inc	b
		ld	a,b
		cp	6
		jr	nz,.loop
		ret
