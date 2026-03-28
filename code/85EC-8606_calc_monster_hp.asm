dyn_proc_94:				; RST_10_5C
		push	de
		ld	d, a

		GET_A_FROM_TABLE	INX_MONST_HP_AC

		call	divide_A_by_16
		ld	e, a

		GET_D_FROM_TABLE	INX_OPTION_KEYS

		call	divide_A_by_16

		GET_A_FROM_TABLE	64h

		and	(iy+VAR_RND_HI)
		add	a, e
		pop	de
		ret	nc

		ld	a, 0FFh

		ret
