; --- spring_trap -------------------------------------------
; @done
; Spring a random trap on the party: print "TRAP! You've hit a", pick one of 8 traps,
; print its name (message $28+n = pit / spiked pit / poison gas / ...), then apply its
; effect from trap_effects to each party member and redraw the stats.
spring_trap:
		CLEAR_INFO_PANEL
		PRINT_MESSAGE2 $11		; "TRAP! You've hit a "
		GET_RND_NUMBERS
		and	7
		ld	(treasure_flag),a		; trap index 0..7
		add	a,$28
		PRINT2_A_WITH_FLAG_0		; print trap name (msg $28+n)
		CHANGE_SPEED $08
		call	trap_precheck
		ld	hl,trap_effects+16
		call	roll_damage_from_table
		ld	b,6
		GET_IY_A_FROM_TABLE $36,$53
		jr	nz,.hit_hero
		call	pick_random_hero_lo
		ld	b,a
.hit_hero:
		GET_IY_A_FROM_TABLE $36,$54
		call	make_damage_spec
		call	apply_effect_to_hero
		GET_A_FROM_TABLE $53
		jr	z,.done
		dec	b
		jp	p,.hit_hero
.done:
		jp	print_stats_table
