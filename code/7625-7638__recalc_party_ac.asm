; --- recalc_party_ac --------------------------------------------
; @done
; RECALC_ALL_AC handler: walks all six party slots and recomputes
; each member's armor class (via calc_ac_worker), then repaints the stats
; table.
; In:  iy = game variables base
recalc_party_ac:				; RECALC_ALL_AC
		PUSH_REGS

		ld	b,6

.loop:
		FIND_HERO_BY_B

		GET_B_FROM_TABLE	$45

		ld	e,a
		call	calc_ac_worker
		dec	b
		jp	p,.loop

		jp	print_stats_table
