; --- scan_cells_ahead --------------------------------------
; @done
; Step through the 3 cells ahead in the facing direction, OR-ing their wall bits into
; E and (if a $10 "secret" bit is found and reveal is active) clearing it. Restores
; the party coord afterwards.
; In:  ($5FAE) = facing.  Out: e = accumulated wall/reveal bits, zero flag from E.
scan_cells_ahead:
		ld	hl,(coord_ns)
		push	hl
		ld	e,0
		ld	b,3
.loop:
		ld	a,(facing)
		call	step_in_direction
		call	get_cell_feature
		and	$10			; secret bit?
		jr	z,.accumulate
		ld	a,e
		or	4
		ld	e,a
		GET_GAME_VARIABLE $35		; reveal active?
		jr	z,.accumulate
		ld	a,$EF			; clear the secret bit
		call	mask_cell_byte
.accumulate:
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
		ld	(coord_ns),hl
		ld	a,e
		or	a
		ret
