; --- draw_wall_column ($DA73-$DABC) ----------------------------
; @wip
; Render one 3D-view column/slot: dispatch by wall type, call draw_wall_element.

draw_wall_column:
		ld	b,a
		GET_B_FROM_TABLE $18
		jr	z,.da93
		dec	a
		jr	z,.da85
		dec	a
		jr	z,.da8c
		ld	a,(var_5FD3)
		or	a
		jr	nz,.da8c
.da85:
		ld	e,0
		call	draw_wall_element
		jr	draw_wall_faces.dade
.da8c:
		ld	e,1
		call	draw_wall_element
		jr	draw_wall_faces.dade
.da93:
		GET_B_FROM_TABLE $1b
		jr	z,draw_wall_faces.dade
		dec	a
		jr	z,.daa4
		dec	a
		jr	z,.daab
		ld	a,(var_5FD3)
		or	a
		jr	nz,.daab
.daa4:
		ld	e,4
		call	draw_wall_element
		jr	.dab0
.daab:
		ld	e,5
		call	draw_wall_element
.dab0:
		dec	b
		inc	b
		jr	z,draw_wall_faces.dade
		dec	b
		GET_B_FROM_TABLE $18
		inc	b
		or	a
		jr	nz,draw_wall_faces.dade
		dec	b
