; --- trap_area_damage ($D889-$D8DE) ----------------------------
; @wip
; Trap/spell area damage: print the trap message, play a tune, roll daypart-scaled damage and apply it to party members in a loop.

trap_area_damage:
		CLEAR_INFO_PANEL
		PRINT_MESSAGE2 $11
		GET_RND_NUMBERS
		and	7
		ld	(var_5FE1),a
		add	a,$30
		PRINT2_A_WITH_FLAG_0
		CHANGE_SPEED $08
		call	move_beep
		ld	hl,$d8d7
		call	roll_from_daypart_table
		ld	b,6
		GET_IY_A_FROM_TABLE $36,$53
		jr	nz,.d8b1
		call	pick_random_hero_lo
		ld	b,a
.d8b1:
		GET_IY_A_FROM_TABLE $36,$54
		call	set_damage_state
		call	damage_group_checked
		GET_A_FROM_TABLE $53
		jr	z,.d8c4
		dec	b
		jp	p,.d8b1
.d8c4:
		jp	print_stats_table
		db $00,$00,$00,$01,$01,$00,$00,$06	; ........
		db $01,$01,$01,$01,$00,$00,$01,$00	; ........
		db $01,$02,$02,$01,$02,$04,$03,$01	; ........
