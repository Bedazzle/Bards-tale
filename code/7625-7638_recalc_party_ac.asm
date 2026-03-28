dyn_proc_07:				; RST_10_4A
		PUSH_REGS

		ld	b, 6

loc_7629:
		FIND_HERO_BY_B

		GET_B_FROM_TABLE	45h

		ld	e, a
		call	loc_75C7
		dec	b
		jp	p, loc_7629

		jp	print_stats_table
