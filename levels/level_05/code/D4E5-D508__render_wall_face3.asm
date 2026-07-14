; --- render_wall_face3 ($D4E5-$D508) ----------------------------------
; @done

render_wall_face3:
		call	wall_init_face3
		GET_B_FROM_TABLE $17
		jr	nz,.skip
		call	get_walls_s
		ld	a,h
		GET_B_FROM_LIST $1A
.skip:
		GET_B_FROM_TABLE $18
		jr	nz,.skip2
		call	get_walls_n
		ld	a,h
		GET_B_FROM_LIST $1B
.skip2:
		call	render_wall_flags
		dec	(iy+$39)
		jp	wrap_view_we
