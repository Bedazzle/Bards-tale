; --- step_in_facing ($DD14-$DD4C) ------------------------------
; @wip
; Advance a coord one cell in the facing direction (0-3), wrapping.

step_in_facing:
		dec	a
		jr	z,.dd3a
		dec	a
		jr	z,.dd30
		dec	a
		jr	z,.dd35
		inc	(iy+1)
.dd20:
		ld	a,(iy+1)
		ld	(iy+$38),a
		call	wrap_view_ns
		ld	a,(iy+$38)
		ld	(iy+1),a
		ret
.dd30:
		dec	(iy+1)
		jr	.dd20
.dd35:
		dec	(iy+2)
		jr	.dd3d
.dd3a:
		inc	(iy+2)
.dd3d:
		ld	a,(iy+2)
		ld	(iy+$39),a
		call	wrap_view_we
		ld	a,(iy+$39)
		ld	(iy+2),a
		ret
