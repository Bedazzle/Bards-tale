dyn_proc_74:						; RST_10_42
		GET_ATTR_BY_PARAM	CHAR_SPPT_HI

		jr	nz, loc_759F

		inc	hl

		GET_IY_A_FROM_TABLE	4Bh, 65h

		cp	(hl)
		jr	z, loc_759F

		ccf

		ret

loc_759F:
		GET_IY_A_FROM_TABLE	4Bh, 65h

		and	a

		ret
