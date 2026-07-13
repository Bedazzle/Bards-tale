; --- scan_cells_ahead ($D4B3-$D4EA) ----------------------------
; @wip
; Scan the 3 cells ahead in the facing direction for walls/reveal bits.

scan_cells_ahead:
		ld	hl,(var_5FAC)
		push	hl
		ld	e,0
		ld	b,3
.d4bb:
		ld	a,(var_5FAE)
		call	step_in_facing
		call	get_cell_feature
		and	$10
		jr	z,.d4d6
		ld	a,e
		or	4
		ld	e,a
		GET_GAME_VARIABLE $35
		jr	z,.d4d6
		ld	a,$ef
		call	mask_cell_byte
.d4d6:
		ld	a,(hl)
		and	1
		ld	d,a
		ld	a,(hl)
		srl	a
		or	d
		and	3
		or	e
		ld	e,a
		djnz	.d4bb
		pop	hl
		ld	(var_5FAC),hl
		ld	a,e
		or	a
		ret
