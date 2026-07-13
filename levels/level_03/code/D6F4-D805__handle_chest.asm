; --- handle_chest ($D6F4-$D805) --------------------------------
; @done
; Dispatch[4]: chest interaction (Examine/Open/Disarm/Trap-zap/Leave).

handle_chest:
		SHOW_PIC_BY_PARAM $18
		GET_RND_NUMBERS
		and	3
		ld	e,a
		ld	a,(copy_daypart)
		sla	a
		sla	a
		add	a,e
		GET_A_FROM_TABLE $1E
		ld	(treasure_flag),a
		xor	a
		ld	(DISPLAY_PALETTE),a
.menu:
		CLEAR_INFO_PANEL
		PRINT_MESSAGE2 $06
.wait_key:
		WAIT_KEY_DOWN
		cp	'O'			; Open chest
		jp	z,.open
		cp	'T'			; Trap zap (cast a spell at it)
		jr	z,.trap_zap
		cp	'D'			; Disarm it
		jr	z,.disarm
		cp	'L'			; Leave chest
		jr	z,.leave
		cp	'E'			; Examine it
		jr	nz,.wait_key
		ld	a,8
		call	prompt_pick_hero
		jr	c,.menu
		jr	z,.menu
		PRINT_NEWLINE
		GET_B_FROM_TABLE $1F
		ld	e,a
		ld	a,(DISPLAY_PALETTE)
		ld	d,a
		and	e
		jr	nz,.already
		ld	a,e
		or	d
		ld	(DISPLAY_PALETTE),a
		GET_RND_NUMBERS
		ld	e,a
		ld	a,(ix+$3F)
		cp	e
		jr	c,.found_nothing
		GET_GAME_VARIABLE $36
		jr	z,.found_nothing
		push	af
		PRINT_MESSAGE2 $0F
		pop	af
		call	point_ix_to_record
		PRINT_IX_HERO_NAME
		jr	.play_tune
.trap_zap:
		call	who_cast_spell
		jr	c,.menu
		ld	a,(current_spell)
		cp	3
		jr	nz,.menu
		call	spend_spell_points
		jr	c,.menu
		jr	.wrong_name
.found_nothing:
		PRINT_MESSAGE2 $0B
.play_tune:
		CHANGE_SPEED $08
.redraw:
		jr	.menu
.already:
		PRINT_MESSAGE2 $0C
		jr	.play_tune
.leave:
		inc	(iy+$36)
		ret
.disarm:
		ld	a,10
		call	prompt_pick_hero
		jr	c,.menu
		jr	z,.menu
		ld	(iy+$53),b
		PRINT_MESSAGE2 $0E
		call	enter_text
		jr	c,.redraw
		PRINT_MESSAGE2 $1A
		GET_GAME_VARIABLE $36
		jr	z,.wrong_name
		call	point_ix_to_record
		ld	de,TEXT_BUFFER
		ex	de,hl
.match_loop:
		ld	a,(de)
		cp	$FE
		jr	z,.wrong_name
		cp	(hl)
		jr	nz,.spring_trap
		inc	hl
		inc	de
		jr	.match_loop
.wrong_name:
		PRINT_MESSAGE2 $0D
		ld	(iy+$36),0
		jr	.play_tune
.open:
		ld	a,9
		call	prompt_pick_hero
		jp	c,.menu
		ld	(iy+$53),b
		GET_GAME_VARIABLE $36
		ret	z
.spring_trap:
		PRINT_MESSAGE2 $10
		ld	a,(iy+$36)
		call	point_ix_to_record
		PRINT_IX_HERO_NAME
		CHANGE_SPEED $08
		ld	hl,wandering_creature_data+8
		call	roll_from_daypart_table
		ld	a,(iy+$36)
		cp	3
		jr	c,.dmg_setup
		ld	(iy+$53),6
.dmg_setup:
		ld	b,a
.dmg_loop:
		GET_B_FROM_TABLE $52
		call	set_damage_state
		add	a,15
		call	damage_group_checked
		cp	3
		jr	c,.trap_done
		dec	(iy+$53)
		jp	p,.dmg_loop
.trap_done:
		ld	(iy+$36),0
		jp	print_stats_table
