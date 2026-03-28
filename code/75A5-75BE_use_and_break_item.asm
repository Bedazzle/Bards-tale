loc_75A5:
		inc	a

		GET_ATTR_BY_A

		RST_10_61	67h, 7Fh

		dec	hl

		jr	loc_75B4

loc_75AF:
		push	af
		ld	a, l

		GET_ATTR_BY_A

		pop	af

loc_75B4:
		cp	30h ; '0'
		jr	nc, loc_75BC

		GET_RND_BY_PARAM	3Fh		; 0-63, random chance to break used item

		ret	nz

loc_75BC:
		jp	loc_72A4
