; --- render_wall_face1 ($D5F7-$D61A) -----------------------
; @done

render_wall_face1:
		call	wall_init_face1
		GET_B_FROM_TABLE $18
		jr	nz,.skip
		call	get_walls_w
		ld	a,d
		GET_B_FROM_LIST $1A
.skip:
		GET_B_FROM_TABLE $17
		jr	nz,.skip2
		call	get_walls_e
		ld	a,d
		GET_B_FROM_LIST $1B
.skip2:
		call	render_wall_flags
		dec	(iy+$38)
		jp	wrap_view_ns
