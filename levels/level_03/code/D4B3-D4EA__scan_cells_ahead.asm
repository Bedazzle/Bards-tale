; --- scan_cells_ahead ($D4B3-$D4EA) ----------------------------
; @done
; Scan the 3 cells ahead in the face_direction direction for walls/reveal bits.
; In:  ($5FAE) = face_direction
; Out: e = collected reveal/sense bits

scan_cells_ahead:
		ld	hl,(coord_so_no)
		push	hl			; save the party coord
		ld	e,0			; e = accumulated sense bits
		ld	b,3			; scan the 3 cells ahead
.scan_loop:
		ld	a,(face_direction)		; face_direction
		call	step_in_facing
		call	get_cell_feature
		and	$10			; "special near" feature bit?
		jr	z,.accum
		ld	a,e
		or	4			; -> flag something-special-near
		ld	e,a
		GET_GAME_VARIABLE $35
		jr	z,.accum
		ld	a,$EF			; clear the feature bit once sensed
		call	mask_cell_byte
.accum:
		ld	a,(hl)
		and	1			; wall low bit
		ld	d,a
		ld	a,(hl)
		srl	a
		or	d
		and	3			; -> 2-bit wall code
		or	e
		ld	e,a
		djnz	.scan_loop
		pop	hl
		ld	(coord_so_no),hl		; restore the party coord
		ld	a,e
		or	a
		ret
