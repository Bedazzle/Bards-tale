sub_F259:
		ld	a, e
		or	a
		ret	z

		push	af
		and	0F0h ; 'р'
		jr	z, loc_F284

		pop	af
		push	af
		and	30h ; '0'
		jr	nz, loc_F279

		pop	af
		and	0Fh
		jr	z, loc_F273

		cp	4
		jr	c, loc_F276

		ld	a, 0FFh

		ret

loc_F273:
		ld	a, 0A0h

		ret

loc_F276:
		ld	a, 0A5h

		ret

loc_F279:
		pop	af
		and	0Fh
		jr	z, loc_F281

		ld	a, 0FFh

		ret

loc_F281:
		ld	a, 0F0h

		ret

loc_F284:
		pop	af

		cp	4
		jr	c, loc_F28C

		ld	a, 0Fh

		ret

loc_F28C:
		ld	a, 5

		ret
