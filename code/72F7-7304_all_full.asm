all_full:
		call	loc_7639
		ret	nc

		or	a
		push	af

		PRINT_SPACE_LINE

		PRINT_MESSAGE	1Ah			; "All full!"

		pop	af
		scf

		ret
