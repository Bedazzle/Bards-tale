; --- handle_wandering_creature -----------------------------
; @done
; Dispatch[3]: a wandering creature offers to join the party (msg 18): keys
; (L)eave, (A)llow -> summon/join, (F)ight -> combat. Builds the creature stats
; from the level's guardian table (ADDR_TABLE $54) and drives the outcome.
; Sub-routines: enc_pick_hero (choose a target hero), enc_start_combat.
; Also holds encounter sub-routines: give_item_to_party, check_party_alive,
; show_party_loop, fight_or_disbelieve (Ghidra merged this cluster into one function).
handle_wandering_creature:
		GET_RND_NUMBERS
		push	af
		GET_IY_A_FROM_TABLE $54,$4f
		ld	c,a
		GET_IY_A_FROM_TABLE $54,$50
		ld	b,a
		cp	$50
		jr	nz,.chk_hi
		inc	b
.chk_hi:
		pop	af
		and	c
		add	a,b
		jr	nz,.set_guardian
		inc	a
.set_guardian:
		ld	(ACTIVE_GUARDIAN),a
		ld	a,1
		ld	(COMBAT_ACTIVE_FLAG),a
		call	show_some_pictext
		CLEAR_INFO_PANEL
		PRINT_MESSAGE2 $12
.wait_key:
		WAIT_KEY_DOWN
		cp	'L'
		jr	z,.leave
		cp	'A'
		jr	z,.allow
		sub	'F'
		jr	nz,.wait_key
		ld	(enemy_count),a
		inc	(iy+$5b)
		call	combat_foes
.leave:
		CLEAR_INFO_PANEL
		and	a
		ret
.allow:
		call	clean_ally_memory
		ld	a,(ACTIVE_GUARDIAN)
		push	af
		call	calc_monster_hp
		ld	(var_5D19),a
		ld	(var_5D1B),a
		pop	af
		call	build_creature_record
		PRINT_STATS_TABLE
		jr	.leave
give_item_to_party:
		ld	e,a
		ld	d,0
		ld	b,1
.loop:
		ld	a,b
		call	add_item_to_hero
		jp	nc,find_hero_by_B
		inc	b
		ld	a,b
		cp	7
		jr	c,.loop
		pop	bc
		ret
		ld	($d82a),a
		ld	a,b
		call	give_item_to_party
		PRINT_IX_HERO_NAME
		PRINT_MESSAGE $7a
		PRINT_MESSAGE2 $00
		jp	change_speed_8
		push	af
		ld	a,b
		call	fight_or_disbelieve
		pop	bc
		GET_GAME_VARIABLE $51
		ret	z
		ld	(iy+2),b
		ret
		ld	b,6
		ld	c,a
check_party_alive:
		ld	a,c
		call	check_equipped+3
		ret	nc
		djnz	check_party_alive
		ret
		ld	l,a
		ld	h,0
		ld	(iy+$50),0
		ld	b,6
show_party_loop:
		ld	a,b
		call	apply_damage_to_group
		dec	b
		jp	p,show_party_loop
		ret
enc_pick_hero:
		push	af
		PRINT_MESSAGE $1e
		pop	af
		PRINT2_A_WITH_FLAG_0
		PRINT_MESSAGE2 $07
		call	enter_1_to_6
		ret	c
		ld	b,a
		FIND_HERO_BY_B
		ret	z
		CHECK_HERO_STATUS
		ccf
		ret	c
		ld	a,1
		or	a
		ret
fight_or_disbelieve:
		call	enc_start_combat
		ret	nz
		ld	a,$fb
		jp	mask_cell_byte
enc_start_combat:
		ld	(ACTIVE_GUARDIAN),a
		ld	a,1
		ld	(COMBAT_ACTIVE_FLAG),a
		ld	(encounter_ctr),a
		ld	(iy+$4d),0
		call	combat_foes
		GET_GAME_VARIABLE $51
		ret
		push	af
		call	clear_txt_buffer
		pop	af
		call	print_cellars_flag1
		jp	print_loc_name
