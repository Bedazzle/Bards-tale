; --- wc_show_joiner ($D890-$D8A7) ----------------------------------
; @done

wc_show_joiner:
		call	clean_ally_memory
		ld	a,(ACTIVE_GUARDIAN)
		push	af
		call	calc_monster_hp
		ld	(var_5D19),a
		ld	(var_5D1B),a
		pop	af
		call	build_creature_record
		PRINT_STATS_TABLE
		jr	handle_wandering_creature.done
