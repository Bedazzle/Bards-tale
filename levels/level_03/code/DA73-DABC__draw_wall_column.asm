; --- draw_wall_column ($DA73-$DABC) ----------------------------
; @done
; Render one 3D-view column/slot: dispatch by wall type, call draw_wall_element.
; In:  a = view slot / depth

draw_wall_column:
		ld	b,a
		GET_B_FROM_TABLE $18
		jr	z,.near_wall
		dec	a
		jr	z,.face0
		dec	a
		jr	z,.face0_dk
		ld	a,(reveal_secret)
		or	a
		jr	nz,.face0_dk
.face0:
		ld	e,0
		call	draw_wall_element
		jr	draw_wall_faces.mid_walls
.face0_dk:
		ld	e,1
		call	draw_wall_element
		jr	draw_wall_faces.mid_walls
.near_wall:
		GET_B_FROM_TABLE $1B
		jr	z,draw_wall_faces.mid_walls
		dec	a
		jr	z,.near
		dec	a
		jr	z,.near_dk
		ld	a,(reveal_secret)
		or	a
		jr	nz,.near_dk
.near:
		ld	e,4
		call	draw_wall_element
		jr	.check_far
.near_dk:
		ld	e,5
		call	draw_wall_element
.check_far:
		dec	b
		inc	b
		jr	z,draw_wall_faces.mid_walls
		dec	b
		GET_B_FROM_TABLE $18
		inc	b
		or	a
		jr	nz,draw_wall_faces.mid_walls
		dec	b
