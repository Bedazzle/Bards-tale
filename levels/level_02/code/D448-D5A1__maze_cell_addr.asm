; --- maze_cell_addr + 3D-view wall scanners ----------------
; @done
; maze_cell_addr: address of a maze cell = MAZE_WALLS + (row+1)*22 + col.
; render_wall_face0..3: per-face_direction view scanners (walk cells in the face_direction dir, read
; the reveal/light wall tables, build wall data via the l_dXXX helpers, advance the
; view coord). render_dungeon_view picks one by face_direction. NOTE: the l_dXXX helpers are
; shared here and still auto-labelled - meaningful names + per-routine split pending.
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
render_wall_face0:
		call	wall_init_face0
		GET_B_FROM_TABLE $17
		jr	nz,.skip1
		call	wall_scan_b
		ld	a,l
		GET_B_FROM_LIST $1b
.skip1:
		GET_B_FROM_TABLE $18
		jr	nz,.skip2
		call	wall_scan_a
		ld	a,l
		GET_B_FROM_LIST $1a
.skip2:
		call	build_wall_data
		inc	(iy+$38)
		jp	wrap_view_ns
render_wall_face2:
		call	wall_init_face2
		GET_B_FROM_TABLE $18
		jr	nz,.skip1
		call	wall_scan_b
		ld	a,d
		GET_B_FROM_LIST $1a
.skip1:
		GET_B_FROM_TABLE $17
		jr	nz,.skip2
		call	wall_scan_a
		ld	a,d
		GET_B_FROM_LIST $1b
.skip2:
		call	build_wall_data
		dec	(iy+$38)
		jp	wrap_view_ns
render_wall_face1:
		ld	a,b
		call	wall_init_face1
		GET_B_FROM_TABLE $18
		jr	nz,.skip1
		call	wall_scan_d
		ld	a,e
		GET_B_FROM_LIST $1b
.skip1:
		GET_B_FROM_TABLE $17
		jr	nz,.skip2
		call	wall_scan_c
		ld	a,e
		GET_B_FROM_LIST $1a
.skip2:
		call	build_wall_data
		inc	(iy+$39)
		jp	wrap_view_we
render_wall_face3:
		call	wall_init_face3
		GET_B_FROM_TABLE $17
		jr	nz,.skip1
		call	wall_scan_d
		ld	a,h
		GET_B_FROM_LIST $1a
.skip1:
		GET_B_FROM_TABLE $18
		jr	nz,.skip2
		call	wall_scan_c
		ld	a,h
		GET_B_FROM_LIST $1b
.skip2:
		call	build_wall_data
		dec	(iy+$39)
		jp	wrap_view_we
wall_scan_a:
		inc	(iy+$39)
		call	wrap_view_we
		call	get_wall_byte
		dec	(iy+$39)
		jp	wrap_view_we
wall_scan_b:
		dec	(iy+$39)
		call	wrap_view_we
		call	get_wall_byte
		inc	(iy+$39)
		jp	wrap_view_we
wall_scan_c:
		dec	(iy+$38)
		call	wrap_view_ns
		call	get_wall_byte
		inc	(iy+$38)
		jp	wrap_view_ns
wall_scan_d:
		inc	(iy+$38)
		call	wrap_view_ns
		call	get_wall_byte
		dec	(iy+$38)
		jp	wrap_view_ns
wall_init_face0:
		call	get_wall_byte
		ld	a,l
		GET_B_FROM_LIST $19
		ld	a,e
		GET_B_FROM_LIST $17
		ld	a,h
		GET_B_FROM_LIST $18
		ret
wall_init_face2:
		call	get_wall_byte
		ld	a,d
		GET_B_FROM_LIST $19
		ld	a,e
		GET_B_FROM_LIST $18
		ld	a,h
		GET_B_FROM_LIST $17
		ret
wall_init_face1:
		call	get_wall_byte
		ld	a,l
		GET_B_FROM_LIST $18
		ld	a,d
		GET_B_FROM_LIST $17
		ld	a,e
		GET_B_FROM_LIST $19
		ret
wall_init_face3:
		call	get_wall_byte
		ld	a,l
		GET_B_FROM_LIST $17
		ld	a,d
		GET_B_FROM_LIST $18
		ld	a,h
		GET_B_FROM_LIST $19
		ret
get_wall_byte:
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
build_wall_data:
		push	bc
		ld	bc,(view_y_offset)
		call	maze_cell_addr
		ld	de,$1e4
		add	hl,de
		ld	a,(hl)
		and	$20
		push	af
		ld	a,(hl)
		and	$40
		pop	hl
		pop	bc
		GET_B_FROM_LIST $1d
		ld	a,h
		GET_B_FROM_LIST $1c
		ret

