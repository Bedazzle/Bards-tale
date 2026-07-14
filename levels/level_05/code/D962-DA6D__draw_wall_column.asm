; --- draw_wall_column ($D962-$DA6D) ----------------------------------
; @done
; Render one 3D-view column/slot: dispatch by wall type, call draw_wall_element.
; In:  a = view slot / depth

draw_wall_column:
		ld	b,a
		GET_B_FROM_TABLE $18
		jr	z,.skip3
		dec	a
		jr	z,.skip
		dec	a
		jr	z,.skip2
		ld	a,(reveal_secret)
		or	a
		jr	nz,.skip2
.skip:
		ld	e,0
		call	draw_wall_element
		jr	.skip9
.skip2:
		ld	e,1
		call	draw_wall_element
		jr	.skip9
.skip3:
		GET_B_FROM_TABLE $1B
		jr	z,.skip9
		dec	a
		jr	z,.skip4
		dec	a
		jr	z,.skip5
		ld	a,(reveal_secret)
		or	a
		jr	nz,.skip5
.skip4:
		ld	e,4
		call	draw_wall_element
		jr	.skip6
.skip5:
		ld	e,5
		call	draw_wall_element
.skip6:
		dec	b
		inc	b
		jr	z,.skip9
		dec	b
		GET_B_FROM_TABLE $18
		inc	b
		or	a
		jr	nz,.skip9
		dec	b
		GET_B_FROM_TABLE $1B
		inc	b
		or	a
		jr	nz,.skip9
		GET_B_FROM_TABLE $1B
		dec	a
		jr	z,.skip7
		dec	a
		jr	z,.skip8
		ld	a,(reveal_secret)
		jr	nz,.skip8
.skip7:
		ld	e,8
		call	draw_wall_element
		jr	.skip9
.skip8:
		ld	e,9
		call	draw_wall_element
.skip9:
		GET_B_FROM_TABLE $17
		jr	z,.skip12
		dec	a
		jr	z,.skip10
		dec	a
		jr	z,.skip11
		ld	a,(reveal_secret)
		or	a
		jr	nz,.skip11
.skip10:
		ld	e,2
		call	draw_wall_element
		jr	.skip18
.skip11:
		ld	e,3
		call	draw_wall_element
		jr	.skip18
.skip12:
		GET_B_FROM_TABLE $1A
		jr	z,.skip18
		dec	a
		jr	z,.skip13
		dec	a
		jr	z,.skip14
		ld	a,(reveal_secret)
		or	a
		jr	nz,.skip14
.skip13:
		ld	e,6
		call	draw_wall_element
		jr	.skip15
.skip14:
		ld	e,7
		call	draw_wall_element
.skip15:
		dec	b
		inc	b
		jr	z,.skip18
		dec	b
		GET_B_FROM_TABLE $17
		inc	b
		or	a
		jr	nz,.skip18
		dec	b
		GET_B_FROM_TABLE $1A
		inc	b
		or	a
		jr	nz,.skip18
		GET_B_FROM_TABLE $1A
		dec	a
		jr	z,.skip16
		dec	a
		jr	z,.skip17
		ld	a,(reveal_secret)
		or	a
		jr	nz,.skip17
.skip16:
		ld	e,10
		call	draw_wall_element
		jr	.skip18
.skip17:
		ld	e,11
		call	draw_wall_element
.skip18:
		GET_B_FROM_TABLE $19
		jr	z,.done
		pop	hl
		pop	hl
		dec	a
		jr	z,.skip19
		dec	a
		jr	z,.skip20
		ld	a,(reveal_secret)
		or	a
		jr	nz,.skip20
.skip19:
		ld	e,12
		call	draw_wall_element
		jr	.done
.skip20:
		ld	e,13
		call	draw_wall_element
.done:
		ld	a,b
		or	a
		ret	z
		GET_B_FROM_TABLE $1D
		jr	z,.done2
		ld	e,14
		call	draw_wall_element
.done2:
		GET_B_FROM_TABLE $1C
		ret	z
		ld	e,15
		call	draw_wall_element
		ret
