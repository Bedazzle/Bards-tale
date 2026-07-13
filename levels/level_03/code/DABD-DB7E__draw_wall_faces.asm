; --- draw_wall_faces ($DABD-$DB7E) -----------------------------
; @wip
; Render all wall faces/edges for a cell: test each reveal/pattern slot (GET_B_FROM_TABLE $17-$1d) and blit the matching element (draw_wall_element e=2..15).

draw_wall_faces:
		GET_B_FROM_TABLE $1b
		inc	b
		or	a
		jr	nz,.dade
		GET_B_FROM_TABLE $1b
		dec	a
		jr	z,.dad2
		dec	a
		jr	z,.dad9
		ld	a,(var_5FD3)
		jr	nz,.dad9
.dad2:
		ld	e,8
		call	draw_wall_element
		jr	.dade
.dad9:
		ld	e,9
		call	draw_wall_element
.dade:
		GET_B_FROM_TABLE $17
		jr	z,.dafd
		dec	a
		jr	z,.daef
		dec	a
		jr	z,.daf6
		ld	a,(var_5FD3)
		or	a
		jr	nz,.daf6
.daef:
		ld	e,2
		call	draw_wall_element
		jr	.db49
.daf6:
		ld	e,3
		call	draw_wall_element
		jr	.db49
.dafd:
		GET_B_FROM_TABLE $1a
		jr	z,.db49
		dec	a
		jr	z,.db0e
		dec	a
		jr	z,.db15
		ld	a,(var_5FD3)
		or	a
		jr	nz,.db15
.db0e:
		ld	e,6
		call	draw_wall_element
		jr	.db1a
.db15:
		ld	e,7
		call	draw_wall_element
.db1a:
		dec	b
		inc	b
		jr	z,.db49
		dec	b
		GET_B_FROM_TABLE $17
		inc	b
		or	a
		jr	nz,.db49
		dec	b
		GET_B_FROM_TABLE $1a
		inc	b
		or	a
		jr	nz,.db49
		GET_B_FROM_TABLE $1a
		dec	a
		jr	z,.db3d
		dec	a
		jr	z,.db44
		ld	a,(var_5FD3)
		or	a
		jr	nz,.db44
.db3d:
		ld	e,10
		call	draw_wall_element
		jr	.db49
.db44:
		ld	e,11
		call	draw_wall_element
.db49:
		GET_B_FROM_TABLE $19
		jr	z,.db68
		pop	hl
		pop	hl
		dec	a
		jr	z,.db5c
		dec	a
		jr	z,.db63
		ld	a,(var_5FD3)
		or	a
		jr	nz,.db63
.db5c:
		ld	e,12
		call	draw_wall_element
		jr	.db68
.db63:
		ld	e,13
		call	draw_wall_element
.db68:
		ld	a,b
		or	a
		ret	z
		GET_B_FROM_TABLE $1d
		jr	z,.db75
		ld	e,14
		call	draw_wall_element
.db75:
		GET_B_FROM_TABLE $1c
		ret	z
		ld	e,15
		call	draw_wall_element
		ret
