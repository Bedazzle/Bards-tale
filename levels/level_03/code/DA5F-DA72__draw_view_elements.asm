; --- draw_view_elements ($DA5F-$DA72) --------------------------
; @done
; Render the 3D view: loop 5 depth slots calling draw_wall_column.

draw_view_elements:
		ld	(iy+6),1
		xor	a			; slot = 0
.slot_loop:
		cp	(iy+$27)		; stop at the darkness depth limit
		ret	z
		push	af
		call	draw_wall_column
		pop	af
		inc	a
		cp	5			; 5 depth slots
		jr	nz,.slot_loop
		ret
