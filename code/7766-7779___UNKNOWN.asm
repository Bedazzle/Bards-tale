dyn_proc_59:								; RST_10_2E
		EXEC_FOR_HEROES	loc_776B

		ret

loc_776B:
		CHECK_HERO_STATUS

		ccf
		jr	nc, loc_7777

		GET_ATTR_BY_PARAM_SAVE_HL	CHAR_NEG_FLAG

		jr	nz, loc_7777
		scf

		ret

loc_7777:
		pop	af
		and	a

		ret
