; --- render_dungeon_view -----------------------------------
; @done
; Draw the 3D dungeon view. If the darkness var ($40) is set the walls are skipped
; (black view). Otherwise it clears the light-spell state, copies the party coord to
; the view coord, selects the wall renderer for the current face_direction ($03) out of four
; (one per direction), and calls it via an SMC slot for each of the 5 depth steps,
; then finishes with draw_view_elements.
render_dungeon_view:
		inc	(iy+$30)
		ld	a,$45
		call	prep_black_color
		CLEAR_INFO_PANEL
		GET_GAME_VARIABLE $40		; darkness -> skip walls
		jr	nz,.done
		ld	hl,SPELL_LIGHT_STATE
		ld	b,35
.clear_light:
		ld	(hl),0
		inc	hl
		djnz	.clear_light
		ld	hl,(coord_so_no)		; party coord -> view coord
		ld	(view_y_offset),hl
		ld	b,0
		GET_GAME_VARIABLE $03		; face_direction 0..3
		jr	z,.face0
		dec	a
		jr	z,.face1
		dec	a
		jr	z,.face2
		ld	hl,render_wall_face3
		jr	.select

.face2:
		ld	hl,render_wall_face2
		jr	.select

.face1:
		ld	hl,render_wall_face1
		jr	.select

.face0:
		ld	hl,render_wall_face0
.select:
		ld	(.render_op),hl		; patch SMC call target
.render:
		call	$0000			; -> selected wall renderer
.render_op EQU $-2
		inc	b
		ld	a,b
		cp	5			; 5 depth steps
		jr	c,.render
.done:
		call	draw_view_elements
		dec	(iy+$30)
		ret
