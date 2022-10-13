sub_7DB8:
		ld	e, 34h ; '4'

loc_7DBA:
		inc	(iy+VAR_PAUSE)		; pause ON
		call	loc_7DC4
		dec	(iy+VAR_PAUSE)		; pause OFF

		ret

; -------------------------------------

loc_7DC4:
		ld	b, 6

loc_7DC6:
		FIND_HERO_BY_B

		jr	z, loc_7DEF

loc_7DCA:
		inc	(iy+VAR_PAUSE)		; pause ON

		PUSH_REGS

		CHECK_HERO_STATUS

		jr	z, loc_7DD7

		cp	5
		jr	c, loc_7DEC

loc_7DD7:
		ld	a, e

		GET_ATTR_BY_A

		call	sub_7DF4
		jr	nz, loc_7DE6

		dec	hl
		call	sub_7DF4
		jr	z, loc_7DEC

		dec	hl

loc_7DE6:
		inc	hl
		inc	(hl)
		jr	nz, loc_7DEC

		dec	hl
		inc	(hl)

loc_7DEC:
		dec	(iy+VAR_PAUSE)		; pause OFF

loc_7DEF:
		djnz	loc_7DC6

		jp	print_stats_table

; ======= S U B	R O U T	I N E =========


sub_7DF4:
		ld	a, (hl)
		inc	hl
		inc	hl

		cp	(hl)

		ret
