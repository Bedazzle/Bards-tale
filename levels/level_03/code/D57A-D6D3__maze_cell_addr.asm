; ============================================================================
; Level 03 (Sewers 1) - maze cell addressing + the 3D wall-face renderers
; ----------------------------------------------------------------------------
; @done  maze_cell_addr + the 4 per-face_direction wall renderers (render_wall_face0..3,
; SMC-selected into the $D56B slot by redraw_location) and their helpers. The
; renderers were SMC-reached code the disassembler left as DB; recovered here.
; ============================================================================

; --- maze_cell_addr ------------------------------
; @done
; Compute the maze cell address: MAZE_WALLS + (row+1)*22 + col.
; In:  c = row, b = col
; Out: hl = cell address, a = (hl)
maze_cell_addr:
		ld	hl,MAZE_WALLS
		ld	de,$16
.loop:
		add	hl,de
		dec	c
		jp	p,.loop
		ld	e,b
		add	hl,de
		ld	a,(hl)
		ret
; --- render_wall_face0 ---------------------------
; @done
; Draw the wall faces for view face_direction 0 (SMC-selected by redraw_location).
render_wall_face0:
		call	wall_init_face0
		GET_B_FROM_TABLE $17
		jr	nz,.wall2
		call	get_walls_w
		ld	a,l
		GET_B_FROM_LIST $1B
.wall2:
		GET_B_FROM_TABLE $18
		jr	nz,.finish
		call	get_walls_e
		ld	a,l
		GET_B_FROM_LIST $1A
.finish:
		call	render_wall_flags
		inc	(iy+$38)
		jp	wrap_view_ns
; --- render_wall_face1 ---------------------------
; @done
; Draw the wall faces for view face_direction 1.
render_wall_face1:
		call	wall_init_face1
		GET_B_FROM_TABLE $18
		jr	nz,.wall2
		call	get_walls_w
		ld	a,d
		GET_B_FROM_LIST $1A
.wall2:
		GET_B_FROM_TABLE $17
		jr	nz,.finish
		call	get_walls_e
		ld	a,d
		GET_B_FROM_LIST $1B
.finish:
		call	render_wall_flags
		dec	(iy+$38)
		jp	wrap_view_ns
; --- render_wall_face2 ---------------------------
; @done
; Draw the wall faces for view face_direction 2.
render_wall_face2:
		ld	a,b
		call	wall_init_face2
		GET_B_FROM_TABLE $18
		jr	nz,.wall2
		call	get_walls_s
		ld	a,e
		GET_B_FROM_LIST $1B
.wall2:
		GET_B_FROM_TABLE $17
		jr	nz,.finish
		call	get_walls_n
		ld	a,e
		GET_B_FROM_LIST $1A
.finish:
		call	render_wall_flags
		inc	(iy+$39)
		jp	wrap_view_we
; --- render_wall_face3 ---------------------------
; @done
; Draw the wall faces for view face_direction 3.
render_wall_face3:
		call	wall_init_face3
		GET_B_FROM_TABLE $17
		jr	nz,.wall2
		call	get_walls_s
		ld	a,h
		GET_B_FROM_LIST $1A
.wall2:
		GET_B_FROM_TABLE $18
		jr	nz,.finish
		call	get_walls_n
		ld	a,h
		GET_B_FROM_LIST $1B
.finish:
		call	render_wall_flags
		dec	(iy+$39)
		jp	wrap_view_we
; --- get_walls_e ---------------------------------
; @done
; Fetch the east-neighbour cell walls (unpack_cell_walls on W/E+1).
get_walls_e:
		inc	(iy+$39)
		call	wrap_view_we
		call	unpack_cell_walls
		dec	(iy+$39)
		jp	wrap_view_we
; --- get_walls_w ---------------------------------
; @done
; Fetch the west-neighbour cell walls (W/E-1).
get_walls_w:
		dec	(iy+$39)
		call	wrap_view_we
		call	unpack_cell_walls
		inc	(iy+$39)
		jp	wrap_view_we
; --- get_walls_n ---------------------------------
; @done
; Fetch the north-neighbour cell walls (N/S-1).
get_walls_n:
		dec	(iy+$38)
		call	wrap_view_ns
		call	unpack_cell_walls
		inc	(iy+$38)
		jp	wrap_view_ns
; --- get_walls_s ---------------------------------
; @done
; Fetch the south-neighbour cell walls (N/S+1).
get_walls_s:
		inc	(iy+$38)
		call	wrap_view_ns
		call	unpack_cell_walls
		dec	(iy+$38)
		jp	wrap_view_ns
; --- wall_init_face0 -----------------------------
; @done
; Per-face_direction view setup for face_direction 0: fetch this cell + the reveal/light states.
wall_init_face0:
		call	unpack_cell_walls
		ld	a,l
		GET_B_FROM_LIST $19
		ld	a,e
		GET_B_FROM_LIST $17
		ld	a,h
		GET_B_FROM_LIST $18
		ret
; --- wall_init_face1 -----------------------------
; @done
; Per-face_direction view setup for face_direction 1.
wall_init_face1:
		call	unpack_cell_walls
		ld	a,d
		GET_B_FROM_LIST $19
		ld	a,e
		GET_B_FROM_LIST $18
		ld	a,h
		GET_B_FROM_LIST $17
		ret
; --- wall_init_face2 -----------------------------
; @done
; Per-face_direction view setup for face_direction 2.
wall_init_face2:
		call	unpack_cell_walls
		ld	a,l
		GET_B_FROM_LIST $18
		ld	a,d
		GET_B_FROM_LIST $17
		ld	a,e
		GET_B_FROM_LIST $19
		ret
; --- wall_init_face3 -----------------------------
; @done
; Per-face_direction view setup for face_direction 3.
wall_init_face3:
		call	unpack_cell_walls
		ld	a,l
		GET_B_FROM_LIST $17
		ld	a,d
		GET_B_FROM_LIST $18
		ld	a,h
		GET_B_FROM_LIST $19
		ret
; --- unpack_cell_walls ---------------------------
; @done
; Read the view cell and unpack its wall byte into the 4 directional nibbles (d/e/l/c).
unpack_cell_walls:
		push	bc
		ld	bc,(view_y_offset)
		call	maze_cell_addr
		ld	l,a
		and	3
		ld	c,a
		ld	b,3
.loop:
		ld	a,l
		srl	a
		srl	a
		ld	l,a
		and	3
		push	af
		djnz	.loop
		pop	hl
		pop	af
		ld	e,a
		pop	af
		ld	d,a
		ld	l,c
		pop	bc
		ret
; --- render_wall_flags ---------------------------
; @done
; Read the cell feature byte, test the $20/$40 special-wall flags and draw the wall overlays.
render_wall_flags:
		push	bc
		ld	bc,(view_y_offset)
		call	maze_cell_addr
		ld	de,$1E4
		add	hl,de
		ld	a,(hl)
		and	$20
		push	af
		ld	a,(hl)
		and	$40
		pop	hl
		pop	bc
		GET_B_FROM_LIST $1D
		ld	a,h
		GET_B_FROM_LIST $1C
		ret
