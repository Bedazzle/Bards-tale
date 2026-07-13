; --- redraw_location ($D529-$D579) -----------------------------
; @wip
; Prepare + redraw the 3D location view: clear panel, reset light state, set view coords.

redraw_location:
		inc	(iy+$30)
		ld	a,$43
		call	prep_black_color
		CLEAR_INFO_PANEL
		GET_GAME_VARIABLE $40
		jr	nz,.d573
		ld	hl,SPELL_LIGHT_STATE
		ld	b,$23
.d53d:
		ld	(hl),0
		inc	hl
		djnz	.d53d
		ld	hl,(var_5FAC)
		ld	(var_5FE3),hl
		ld	b,0
		GET_GAME_VARIABLE $03
		jr	z,.d564
		dec	a
		jr	z,.d55f
		dec	a
		jr	z,.d55a
		ld	hl,$d5f6
		jr	.d567
.d55a:
		ld	hl,$d5ad
		jr	.d567
.d55f:
		ld	hl,$d5d1
		jr	.d567
.d564:
		ld	hl,$d589
.d567:
		ld	($d56b),hl
.d56a:
		call	CHAR_NAME
		inc	b
		ld	a,b
		cp	5
		jr	c,.d56a
.d573:
		call	draw_view_elements
		dec	(iy+$30)
		ret
