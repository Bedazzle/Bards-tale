; --- handle_wandering_creature ($D8DF-$D98A) -------------------
; @wip
; Dispatch[3]: wandering-creature encounter (offer join / fight / leave).

handle_wandering_creature:
		GET_RND_NUMBERS
		push	af
		GET_IY_A_FROM_TABLE $54,$4f
		ld	c,a
		GET_IY_A_FROM_TABLE $54,$50
		ld	b,a
		cp	$50
		jr	nz,.d8f1
		inc	b
.d8f1:
		pop	af
		and	c
		add	a,b
		jr	nz,.d8f7
		inc	a
.d8f7:
		ld	(ACTIVE_GUARDIAN),a
		ld	a,1
		ld	(COMBAT_ACTIVE_FLAG),a
		call	show_some_pictext
		CLEAR_INFO_PANEL
		PRINT_MESSAGE2 $12
.d907:
		WAIT_KEY_DOWN
		cp	$4c
		jr	z,.d91e
		cp	$41
		jr	z,.d922
		sub	$46
		jr	nz,.d907
		ld	(var_5FF8),a
		inc	(iy+$5b)
		call	combat_foes
.d91e:
		CLEAR_INFO_PANEL
		and	a
		ret
.d922:
		call	clean_ally_memory
		ld	a,(ACTIVE_GUARDIAN)
		push	af
		call	calc_monster_hp
		ld	(var_5D19),a
		ld	(var_5D1B),a
		pop	af
		call	build_creature_record
		PRINT_STATS_TABLE
		jr	.d91e
		db $5f,$16,$00,$06,$01,$78,$cd,$39	; _....x.9
		db $76,$d2,$d9,$61,$04,$78,$fe,$07	; v..a.x..
		db $38,$f3,$c1,$c9,$32,$5c,$d9,$78	; 8...2\.x
		db $cd,$3a,$d9,$d7,$13,$d7,$07,$7a	; .:.....z
		db $d7,$0b,$00,$c3,$09,$75,$f5,$78	; .....u.x
		db $cd,$a5,$d9,$c1,$d7,$19,$51,$c8	; ......Q.
		db $fd,$70,$02,$c9,$06,$06,$4f,$79	; .p....Oy
		db $cd,$da,$6c,$d0,$10,$f9,$c9,$6f	; ..l....o
		db $26,$00,$fd,$36,$50,$00,$06,$06	; &..6P...
		db $78,$cd,$4e,$7c,$05,$f2,$82,$d9	; x.N|....
		db $c9	; .
