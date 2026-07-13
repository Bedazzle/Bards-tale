; --- draw_view_elements ($DA5F-$DA72) --------------------------
; @wip
; Render the 3D view: loop 5 depth slots calling draw_wall_column.

draw_view_elements:
		ld	(iy+6),1
		xor	a
.da64:
		cp	(iy+$27)
		ret	z
		push	af
		call	draw_wall_column
		pop	af
		inc	a
		cp	5
		jr	nz,.da64
		ret
