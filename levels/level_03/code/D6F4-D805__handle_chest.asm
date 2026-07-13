; --- handle_chest ($D6F4-$D805) --------------------------------
; @wip
; Dispatch[4]: chest interaction (Examine/Open/Disarm/Trap-zap/Leave).

handle_chest:
		SHOW_PIC_BY_PARAM $18
		GET_RND_NUMBERS
		and	3
		ld	e,a
		ld	a,(var_5FFF)
		sla	a
		sla	a
		add	a,e
		GET_A_FROM_TABLE $1e
		ld	(var_5FE1),a
		xor	a
		ld	(DISPLAY_PALETTE),a
.d70e:
		CLEAR_INFO_PANEL
		PRINT_MESSAGE2 $06
.d713:
		WAIT_KEY_DOWN
		cp	$4f
		jp	z,.d7bb
		cp	$54
		jr	z,.d75f
		cp	$44
		jr	z,.d783
		cp	$4c
		jr	z,.d77f
		cp	$45
		jr	nz,.d713
		ld	a,8
		call	prompt_pick_hero
		jr	c,.d70e
		jr	z,.d70e
		PRINT_NEWLINE
		GET_B_FROM_TABLE $1f
		ld	e,a
		ld	a,(DISPLAY_PALETTE)
		ld	d,a
		and	e
		jr	nz,.d77a
		ld	a,e
		or	d
		ld	(DISPLAY_PALETTE),a
		GET_RND_NUMBERS
		ld	e,a
		ld	a,(ix+$3f)
		cp	e
		jr	c,.d772
		GET_GAME_VARIABLE $36
		jr	z,.d772
		push	af
		PRINT_MESSAGE2 $0f
		pop	af
		call	point_ix_to_record
		PRINT_IX_HERO_NAME
		jr	.d775
.d75f:
		call	who_cast_spell
		jr	c,.d70e
		ld	a,(var_5FF6)
		cp	3
		jr	nz,.d70e
		call	spend_spell_points
		jr	c,.d70e
		jr	.d7b2
.d772:
		PRINT_MESSAGE2 $0b
.d775:
		CHANGE_SPEED $08
.d778:
		jr	.d70e
.d77a:
		PRINT_MESSAGE2 $0c
		jr	.d775
.d77f:
		inc	(iy+$36)
		ret
.d783:
		ld	a,10
		call	prompt_pick_hero
		jr	c,.d70e
		jr	z,.d70e
		ld	(iy+$53),b
		PRINT_MESSAGE2 $0e
		call	enter_text
		jr	c,.d778
		PRINT_MESSAGE2 $1a
		GET_GAME_VARIABLE $36
		jr	z,.d7b2
		call	point_ix_to_record
		ld	de,TEXT_BUFFER
		ex	de,hl
.d7a6:
		ld	a,(de)
		cp	$fe
		jr	z,.d7b2
		cp	(hl)
		jr	nz,.d7ca
		inc	hl
		inc	de
		jr	.d7a6
.d7b2:
		PRINT_MESSAGE2 $0d
		ld	(iy+$36),0
		jr	.d775
.d7bb:
		ld	a,9
		call	prompt_pick_hero
		jp	c,.d70e
		ld	(iy+$53),b
		GET_GAME_VARIABLE $36
		ret	z
.d7ca:
		PRINT_MESSAGE2 $10
		ld	a,(iy+$36)
		call	point_ix_to_record
		PRINT_IX_HERO_NAME
		CHANGE_SPEED $08
		ld	hl,$d80e
		call	roll_from_daypart_table
		ld	a,(iy+$36)
		cp	3
		jr	c,.d7e9
		ld	(iy+$53),6
.d7e9:
		ld	b,a
.d7ea:
		GET_B_FROM_TABLE $52
		call	set_damage_state
		add	a,15
		call	damage_group_checked
		cp	3
		jr	c,.d7ff
		dec	(iy+$53)
		jp	p,.d7ea
.d7ff:
		ld	(iy+$36),0
		jp	print_stats_table
