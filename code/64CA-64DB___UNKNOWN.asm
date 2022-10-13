dyn_proc_08:			; RST_10_61
		push	de
		ld	d, a
		call	get_param_to_A
		ld	(byte_64D6+2), a
		call	get_param_to_A
		ld	e, a

byte_64D6:
		GET_D_FROM_TABLE	INX_ITEM_EFFECTS

		and	e
		pop	de

		ret
