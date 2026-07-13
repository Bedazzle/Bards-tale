; --- draw_view_elements ($DAA9-$DABC) ----------------------
; @done
; Render the 3D view: loop 5 depth slots calling draw_wall_column.

draw_view_elements:
		ld	(iy+6),1
		xor	a
.loop:
		cp	(iy+$27)
		ret	z
		push	af
		call	draw_wall_column
		pop	af
		inc	a
		cp	5
		jr	nz,.loop
		ret
