; --- redraw_location ($D573-$D5C3) -------------------------
; @done
; Prepare + redraw the 3D location view: clear panel, reset light state, set view coords.

redraw_location:
		inc	(iy+$30)
		ld	a,$43
		call	prep_black_color
		CLEAR_INFO_PANEL
		GET_GAME_VARIABLE $40
		jr	nz,.done
		ld	hl,SPELL_LIGHT_STATE
		ld	b,$23
.loop:
		ld	(hl),0
		inc	hl
		djnz	.loop
		ld	hl,(coord_so_no)
		ld	(view_y_offset),hl
		ld	b,0
		GET_GAME_VARIABLE $03
		jr	z,.skip3
		dec	a
		jr	z,.skip2
		dec	a
		jr	z,.skip
		ld	hl,render_wall_face3
		jr	.skip4
.skip:
		ld	hl,render_wall_face1
		jr	.skip4
.skip2:
		ld	hl,render_wall_face2
		jr	.skip4
.skip3:
		ld	hl,render_wall_face0
.skip4:
		ld	($D5B5),hl
.loop2:
		call	CHAR_NAME
		inc	b
		ld	a,b
		cp	5
		jr	c,.loop2
.done:
		call	draw_view_elements
		dec	(iy+$30)
		ret
