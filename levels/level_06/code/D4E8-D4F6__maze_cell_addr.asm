; --- maze_cell_addr ($D4E8-$D4F6) ----------------------------------
; Level 03 (Sewers 1) - maze cell addressing + the 3D wall-face renderers
; ----------------------------------------------------------------------------
; @done  maze_cell_addr + the 4 per-face_direction wall renderers (render_wall_face0..3,
; SMC-selected into the $D56B slot by redraw_location) and their helpers. The
; renderers were SMC-reached code the disassembler left as DB; recovered here.
; ============================================================================

maze_cell_addr:
		ld	hl,$F3EA
		ld	de,$16
.loop:
		add	hl,de
		dec	c
		jp	p,.loop
		ld	e,b
		add	hl,de
		ld	a,(hl)
		ret
