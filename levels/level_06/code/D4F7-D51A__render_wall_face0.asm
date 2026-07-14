; --- render_wall_face0 ($D4F7-$D51A) ----------------------------------
; @done

render_wall_face0:
		call	wall_init_face0
		GET_B_FROM_TABLE $17
		jr	nz,.skip
		call	get_walls_w
		ld	a,l
		GET_B_FROM_LIST $1B
.skip:
		GET_B_FROM_TABLE $18
		jr	nz,.skip2
		call	get_walls_e
		ld	a,l
		GET_B_FROM_LIST $1A
.skip2:
		call	render_wall_flags
		inc	(iy+$38)
		jp	wrap_view_ns
