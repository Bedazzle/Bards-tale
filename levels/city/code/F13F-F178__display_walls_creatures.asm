; --- display_walls_creatures --------------------------------------------------
; @done
; Paint the first-person view from the cell buffer that
; DO_SOME_MOVEMENT filled. If the cell directly ahead (VIEW_NEAR_CENTRE)
; maps to a feature picture (table 9), show that full picture and
; return; otherwise draw the eight wall cells VIEW_CELL_0..VIEW_CELL_7,
; rendering each non-empty cell's wall slice (low 3 bits = type)
; through render_sprite_3d.
; In:  VIEW_CELL_0..VIEW_NEAR_CENTRE (view cell buffer)
; Note: brackets the wall pass with VAR_PAUSE on/off; entered by
;       jp from proc_sinistr_strt (a tail-called continuation)
display_walls_creatures:
		ld	a,(VIEW_NEAR_CENTRE)
		or	a
		jr	z,.draw_walls

		call	divide_A_by_8

		GET_A_FROM_TABLE	9

		cp	$FF
		jr	z,.draw_walls

		SHOW_PIC_BY_A

		ret

.draw_walls:
		inc	(iy+VAR_PAUSE)		; pause ON
		ld	(iy+VAR_DISPLAY_STATE),1
		call	set_city_colors
		ld	hl,VIEW_CELL_0
		ld	c,0

.cell_loop:
		push	hl
		push	bc
		ld	a,(hl)
		and	7
		jr	z,.next_cell

		dec	a
		call	render_sprite_3d

.next_cell:
		pop	bc
		pop	hl
		inc	hl
		inc	c
		ld	a,c

		cp	8

.loop_cond:
		jr	c,.cell_loop

		dec	(iy+VAR_PAUSE)		; pause OFF

		ret
