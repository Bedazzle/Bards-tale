; --- redraw_location ($D529-$D579) -----------------------------
; @done
; Prepare + redraw the 3D location view: clear panel, reset light state, set view coords.

redraw_location:
		inc	(iy+$30)
		ld	a,$43
		call	prep_black_color
		CLEAR_INFO_PANEL
		GET_GAME_VARIABLE $40		; darkness? -> skip the walls
		jr	nz,.render
		ld	hl,SPELL_LIGHT_STATE
		ld	b,35			; clear the per-cell light state
.clear_light:
		ld	(hl),0
		inc	hl
		djnz	.clear_light
		ld	hl,(coord_so_no)
		ld	(view_y_offset),hl		; view coord = party coord
		ld	b,0
		GET_GAME_VARIABLE $03		; face_direction -> pick the wall renderer
		jr	z,.face0
		dec	a
		jr	z,.face1
		dec	a
		jr	z,.face2
		ld	hl,render_wall_face3
		jr	.set_renderer
.face2:
		ld	hl,render_wall_face1
		jr	.set_renderer
.face1:
		ld	hl,render_wall_face2
		jr	.set_renderer
.face0:
		ld	hl,render_wall_face0
.set_renderer:
		ld	(.render_op),hl		; patch the SMC call below
.draw_loop:
		call	$0000			; SMC: -> the selected render_wall_faceN (patched above)
.render_op EQU $-2
		inc	b
		ld	a,b
		cp	5			; 5 depth steps
		jr	c,.draw_loop
.render:
		call	draw_view_elements
		dec	(iy+$30)
		ret
