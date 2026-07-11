; --- draw_view_elements ------------------------------------
; @done
; Draw the wall pieces of the 3D view. draw_view_elements loops the visible depth
; positions (up to iy+$27) calling draw_wall_column for each; draw_wall_column reads
; the per-cell wall tables (GET_B_FROM_TABLE $17-$1d) and draws each of the 16 wall
; elements via draw_wall_element, choosing the normal/special variant by ($5FD3).
draw_view_elements:
		ld	(iy+6),1
		xor	a
.join1:
		cp	(iy+$27)
		ret	z
		push	af
		call	draw_wall_column
		pop	af
		inc	a
		cp	5
		jr	nz,.join1
		ret
draw_wall_column:
		ld	b,a
		GET_B_FROM_TABLE $18
		jr	z,.join2
		dec	a
		jr	z,.elem0
		dec	a
		jr	z,.elem1
		ld	a,(var_5FD3)
		or	a
		jr	nz,.elem1
.elem0:
		ld	e,0
		call	draw_wall_element
		jr	.join4
.elem1:
		ld	e,1
		call	draw_wall_element
		jr	.join4
.join2:
		GET_B_FROM_TABLE $1b
		jr	z,.join4
		dec	a
		jr	z,.elem4
		dec	a
		jr	z,.elem5
		ld	a,(var_5FD3)
		or	a
		jr	nz,.elem5
.elem4:
		ld	e,4
		call	draw_wall_element
		jr	.join3
.elem5:
		ld	e,5
		call	draw_wall_element
.join3:
		dec	b
		inc	b
		jr	z,.join4
		dec	b
		GET_B_FROM_TABLE $18
		inc	b
		or	a
		jr	nz,.join4
		dec	b
		GET_B_FROM_TABLE $1b
		inc	b
		or	a
		jr	nz,.join4
		GET_B_FROM_TABLE $1b
		dec	a
		jr	z,.elem8
		dec	a
		jr	z,.elem9
		ld	a,(var_5FD3)
		jr	nz,.elem9
.elem8:
		ld	e,8
		call	draw_wall_element
		jr	.join4
.elem9:
		ld	e,9
		call	draw_wall_element
.join4:
		GET_B_FROM_TABLE $17
		jr	z,.join5
		dec	a
		jr	z,.elem2
		dec	a
		jr	z,.elem3
		ld	a,(var_5FD3)
		or	a
		jr	nz,.elem3
.elem2:
		ld	e,2
		call	draw_wall_element
		jr	.join7
.elem3:
		ld	e,3
		call	draw_wall_element
		jr	.join7
.join5:
		GET_B_FROM_TABLE $1a
		jr	z,.join7
		dec	a
		jr	z,.elem6
		dec	a
		jr	z,.elem7
		ld	a,(var_5FD3)
		or	a
		jr	nz,.elem7
.elem6:
		ld	e,6
		call	draw_wall_element
		jr	.join6
.elem7:
		ld	e,7
		call	draw_wall_element
.join6:
		dec	b
		inc	b
		jr	z,.join7
		dec	b
		GET_B_FROM_TABLE $17
		inc	b
		or	a
		jr	nz,.join7
		dec	b
		GET_B_FROM_TABLE $1a
		inc	b
		or	a
		jr	nz,.join7
		GET_B_FROM_TABLE $1a
		dec	a
		jr	z,.elem10
		dec	a
		jr	z,.elem11
		ld	a,(var_5FD3)
		or	a
		jr	nz,.elem11
.elem10:
		ld	e,10
		call	draw_wall_element
		jr	.join7
.elem11:
		ld	e,11
		call	draw_wall_element
.join7:
		GET_B_FROM_TABLE $19
		jr	z,.join8
		pop	hl
		pop	hl
		dec	a
		jr	z,.elem12
		dec	a
		jr	z,.elem13
		ld	a,(var_5FD3)
		or	a
		jr	nz,.elem13
.elem12:
		ld	e,12
		call	draw_wall_element
		jr	.join8
.elem13:
		ld	e,13
		call	draw_wall_element
.join8:
		ld	a,b
		or	a
		ret	z
		GET_B_FROM_TABLE $1d
		jr	z,.join9
		ld	e,14
		call	draw_wall_element
.join9:
		GET_B_FROM_TABLE $1c
		ret	z
		ld	e,15
		call	draw_wall_element
		ret
