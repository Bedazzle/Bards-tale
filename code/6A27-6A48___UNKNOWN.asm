dyn_proc_60:								; RST_10_2F
		ld	b, 0

		FIND_HERO_BY_B

		jr	z, loc_6A32

		GET_ATTR_BY_PARAM_SAVE_HL	CHAR_PARAMS_HI

		jr	nz, loc_6A47

loc_6A32:
		ld	b, 6

loc_6A34:
		FIND_HERO_BY_B

		jr	z, loc_6A41

		CHECK_HERO_STATUS

		jr	nc, loc_6A41

		GET_ATTR_BY_PARAM_SAVE_HL	CHAR_FORMER_HEALTH

		jr	nz, loc_6A47

loc_6A41:
		dec	b
		jp	p, loc_6A34

		and	a

		ret

loc_6A47:
		scf

		ret
