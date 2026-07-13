; --- draw_wall_faces ($DABD-$DB7E) -----------------------------
; @done
; Render all wall faces/edges for a cell. For each wall (near/left/right/corner/
; far/edge) it reads that wall's reveal slot (GET_B_FROM_TABLE $17-$1D) and blits
; the "lit" element or the "_dk" (dark/secret) variant depending on the reveal
; state and reveal_secret. Element indices 2..15 index the wall_element_table.
; draw_wall_column jumps in at .mid_walls after drawing the front element.

draw_wall_faces:
		GET_B_FROM_TABLE $1B
		inc	b
		or	a
		jr	nz,.mid_walls
		GET_B_FROM_TABLE $1B
		dec	a
		jr	z,.near
		dec	a
		jr	z,.near_dk
		ld	a,(reveal_secret)
		jr	nz,.near_dk
.near:
		ld	e,8
		call	draw_wall_element
		jr	.mid_walls
.near_dk:
		ld	e,9
		call	draw_wall_element
.mid_walls:
		GET_B_FROM_TABLE $17
		jr	z,.right_wall
		dec	a
		jr	z,.left
		dec	a
		jr	z,.left_dk
		ld	a,(reveal_secret)
		or	a
		jr	nz,.left_dk
.left:
		ld	e,2
		call	draw_wall_element
		jr	.far_wall
.left_dk:
		ld	e,3
		call	draw_wall_element
		jr	.far_wall
.right_wall:
		GET_B_FROM_TABLE $1A
		jr	z,.far_wall
		dec	a
		jr	z,.right
		dec	a
		jr	z,.right_dk
		ld	a,(reveal_secret)
		or	a
		jr	nz,.right_dk
.right:
		ld	e,6
		call	draw_wall_element
		jr	.corner_chk
.right_dk:
		ld	e,7
		call	draw_wall_element
.corner_chk:
		dec	b
		inc	b
		jr	z,.far_wall
		dec	b
		GET_B_FROM_TABLE $17
		inc	b
		or	a
		jr	nz,.far_wall
		dec	b
		GET_B_FROM_TABLE $1A
		inc	b
		or	a
		jr	nz,.far_wall
		GET_B_FROM_TABLE $1A
		dec	a
		jr	z,.corner
		dec	a
		jr	z,.corner_dk
		ld	a,(reveal_secret)
		or	a
		jr	nz,.corner_dk
.corner:
		ld	e,10
		call	draw_wall_element
		jr	.far_wall
.corner_dk:
		ld	e,11
		call	draw_wall_element
.far_wall:
		GET_B_FROM_TABLE $19
		jr	z,.edge_chk
		pop	hl
		pop	hl
		dec	a
		jr	z,.far
		dec	a
		jr	z,.far_dk
		ld	a,(reveal_secret)
		or	a
		jr	nz,.far_dk
.far:
		ld	e,12
		call	draw_wall_element
		jr	.edge_chk
.far_dk:
		ld	e,13
		call	draw_wall_element
.edge_chk:
		ld	a,b
		or	a
		ret	z
		GET_B_FROM_TABLE $1D
		jr	z,.edge
		ld	e,14
		call	draw_wall_element
.edge:
		GET_B_FROM_TABLE $1C
		ret	z
		ld	e,15
		call	draw_wall_element
		ret
