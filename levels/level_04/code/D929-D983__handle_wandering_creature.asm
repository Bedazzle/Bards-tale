; --- handle_wandering_creature ($D929-$D983) ---------------
; @done
; Dispatch[3]: wandering-creature encounter (offer join / fight / leave).

handle_wandering_creature:
		GET_RND_NUMBERS
		push	af
		GET_IY_A_FROM_TABLE $54,$4F
		ld	c,a
		GET_IY_A_FROM_TABLE $54,$50
		ld	b,a
		cp	$50
		jr	nz,.skip
		inc	b
.skip:
		pop	af
		and	c
		add	a,b
		jr	nz,.skip2
		inc	a
.skip2:
		ld	(ACTIVE_GUARDIAN),a
		ld	a,1
		ld	(COMBAT_ACTIVE_FLAG),a
		call	show_some_pictext
		CLEAR_INFO_PANEL
		PRINT_MESSAGE2 $12
.loop:
		WAIT_KEY_DOWN
		cp	$4C
		jr	z,.loop2
		cp	$41
		jr	z,.skip3
		sub	$46
		jr	nz,.loop
		ld	(enemy_count),a
		inc	(iy+$5B)
		call	combat_foes
.loop2:
		CLEAR_INFO_PANEL
		and	a
		ret
.skip3:
		call	clean_ally_memory
		ld	a,(ACTIVE_GUARDIAN)
		push	af
		call	calc_monster_hp
		ld	(var_5D19),a
		ld	(var_5D1B),a
		pop	af
		call	build_creature_record
		PRINT_STATS_TABLE
		jr	.loop2
