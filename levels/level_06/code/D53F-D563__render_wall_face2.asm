; --- render_wall_face2 ($D53F-$D563) ----------------------------------
; @done

render_wall_face2:
		ld	a,b
		call	wall_init_face2
		GET_B_FROM_TABLE $18
		jr	nz,.skip
		call	get_walls_s
		ld	a,e
		GET_B_FROM_LIST $1B
.skip:
		GET_B_FROM_TABLE $17
		jr	nz,.skip2
		call	get_walls_n
		ld	a,e
		GET_B_FROM_LIST $1A
.skip2:
		call	render_wall_flags
		inc	(iy+$39)
		jp	wrap_view_we
