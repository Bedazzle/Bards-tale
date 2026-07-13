; --- handle_wandering_creature ($D8DF-$D98A) -------------------
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
		jr	nz,.no_carry
		inc	b
.no_carry:
		pop	af
		and	c
		add	a,b
		jr	nz,.have_id
		inc	a
.have_id:
		ld	(ACTIVE_GUARDIAN),a	; the creature type
		ld	a,1
		ld	(COMBAT_ACTIVE_FLAG),a
		call	show_some_pictext
		CLEAR_INFO_PANEL
		PRINT_MESSAGE2 $12		; "...offers to join... (A)llow/(F)ight/(L)eave"
.wait_key:
		WAIT_KEY_DOWN
		cp	'L'			; leave in peace
		jr	z,.leave
		cp	'A'			; allow it to join
		jr	z,.allow
		sub	'F'			; fight it
		jr	nz,.wait_key
		ld	(enemy_count),a
		inc	(iy+$5B)
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


; --- wandering-creature JOIN helpers ($D93A-$D98A) -----------
; @done  Reached from the (A)llow-join path (computed/SMC dispatch). wc_join_scan
; walks the party looking for a free slot (add_item_to_hero); wc_join_hero prints
; the joining creature onto that hero. wc_join_hero.smc ($D95C) is a self-modified
; sub-block (its first byte is patched by `ld (wc_join_hero.smc),a`) - kept as DB.

wc_join_scan:
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
wc_join_hero:
		ld	($D95C),a
		ld	a,b
		call	wc_join_scan
		PRINT_IX_HERO_NAME
		PRINT_MESSAGE $7A
		PRINT_MESSAGE2 $00
		jp	change_speed_8
		DB $F5,$78,$CD,$A5,$D9,$C1,$D7,$19	; .x......
		DB $51,$C8,$FD,$70,$02,$C9,$06,$06	; Q..p....
		DB $4F	; O
wc_helper1:
		ld	a,c
		call	check_equipped+3
		ret	nc
.loop:
		djnz	wc_helper1
		ret
wc_helper2:
		ld	l,a
		ld	h,0
		ld	(iy+$50),0
		ld	b,6
wc_helper3:
		ld	a,b
		call	apply_damage_to_group
		dec	b
		jp	p,wc_helper3
		ret
