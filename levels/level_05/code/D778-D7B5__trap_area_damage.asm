; --- trap_area_damage ($D778-$D7B5) ----------------------------------
; @done
; Trap/spell area damage: print the trap message, play a tune, roll daypart-scaled damage and apply it to party members in a loop.

trap_area_damage:
		CLEAR_INFO_PANEL
		PRINT_MESSAGE2 $11
		GET_RND_NUMBERS
		and	7
		ld	(treasure_flag),a
		add	a,$28
		PRINT2_A_WITH_FLAG_0
		CHANGE_SPEED $08
		call	move_beep
		ld	hl,$D7C6
		call	roll_from_daypart_table
		ld	b,6
		GET_IY_A_FROM_TABLE $36,$53
		jr	nz,.loop
		call	pick_random_hero_lo
		ld	b,a
.loop:
		GET_IY_A_FROM_TABLE $36,$54
		call	set_damage_state
		call	damage_group_checked
		GET_A_FROM_TABLE $53
		jr	z,.skip
		dec	b
		jp	p,.loop
.skip:
		jp	print_stats_table
