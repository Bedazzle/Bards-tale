loc_F13F:
		ld	a, (byte_FBDF)
		or	a
		jr	z, loc_F152

		call	divide_A_by_8

		GET_A_FROM_TABLE	9

		cp	0FFh
		jr	z, loc_F152

		SHOW_PIC_BY_A

		ret

loc_F152:
		inc	(iy+VAR_PAUSE)		; pause ON
		ld	(iy+VAR_06),	1
		call	set_city_colors
		ld	hl, byte_FBD7
		ld	c, 0

loc_F161:
		push	hl
		push	bc
		ld	a, (hl)
		and	7
		jr	z, loc_F16C

		dec	a
		call	sub_F1A9

loc_F16C:
		pop	bc
		pop	hl
		inc	hl
		inc	c
		ld	a, c

		cp	8

sub_F173:
		jr	c, loc_F161

		dec	(iy+VAR_PAUSE)		; pause OFF

		ret
