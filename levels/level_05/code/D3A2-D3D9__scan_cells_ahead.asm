; --- scan_cells_ahead ($D3A2-$D3D9) ----------------------------------
; @done
; Scan the 3 cells ahead in the face_direction direction for walls/reveal bits.
; In:  ($5FAE) = face_direction
; Out: e = collected reveal/sense bits

scan_cells_ahead:
		ld	hl,(coord_so_no)
		push	hl
		ld	e,0
		ld	b,3
.loop:
		ld	a,(face_direction)
		call	step_in_facing
		call	get_cell_feature
		and	$10
		jr	z,.done
		ld	a,e
		or	4
		ld	e,a
		GET_GAME_VARIABLE $35
		jr	z,.done
		ld	a,$EF
		call	mask_cell_byte
.done:
		ld	a,(hl)
		and	1
		ld	d,a
		ld	a,(hl)
		srl	a
		or	d
		and	3
		or	e
		ld	e,a
		djnz	.loop
		pop	hl
		ld	(coord_so_no),hl
		ld	a,e
		or	a
		ret
