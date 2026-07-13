; --- trap_area_damage ($D889-$D8DE) ----------------------------
; @done
; Trap/spell area damage: print the trap message, play a tune, roll daypart-scaled damage and apply it to party members in a loop.

trap_area_damage:
		CLEAR_INFO_PANEL
		PRINT_MESSAGE2 $11		; "TRAP! You've hit a "
		GET_RND_NUMBERS
		and	7			; random trap flavour 0-7
		ld	(treasure_flag),a
		add	a,$30			; -> ASCII digit
		PRINT2_A_WITH_FLAG_0
		CHANGE_SPEED $08		; play the trap-spell tune
		call	move_beep
		ld	hl,trap_damage_tables+$10
		call	roll_from_daypart_table
		ld	b,6			; up to 6 targets
		GET_IY_A_FROM_TABLE $36,$53
		jr	nz,.apply_loop
		call	pick_random_hero_lo	; pick a random hero to hit
		ld	b,a
.apply_loop:
		GET_IY_A_FROM_TABLE $36,$54
		call	set_damage_state
		call	damage_group_checked
		GET_A_FROM_TABLE $53
		jr	z,.done
		dec	b
		jp	p,.apply_loop
.done:
		jp	print_stats_table

; --- trap_damage_tables ($D8C7) ------------------------------
; @done
; Per-group / per-daypart trap-damage tables: roll_from_daypart_table reads
; from base+$10, and the GET_IY_A_FROM_TABLE $36,$53/$54 lookups index here too.
trap_damage_tables:
		DB $00,$00,$00,$01,$01,$00,$00,$06
		DB $01,$01,$01,$01,$00,$00,$01,$00
		DB $01,$02,$02,$01,$02,$04,$03,$01
