; --- handle_chest ($D5E3-$D6F4) ----------------------------------
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
.loop:
		CLEAR_INFO_PANEL
		PRINT_MESSAGE2 $06
.loop2:
		WAIT_KEY_DOWN
		cp	$4F
		jp	z,.done2
		cp	$54
		jr	z,.skip
		cp	$44
		jr	z,.skip4
		cp	$4C
		jr	z,.done
		cp	$45
		jr	nz,.loop2
		ld	a,8
		call	prompt_pick_hero
		jr	c,.loop
		jr	z,.loop
		PRINT_NEWLINE
		GET_B_FROM_TABLE $1F
		ld	e,a
		ld	a,(DISPLAY_PALETTE)
		ld	d,a
		and	e
		jr	nz,.skip3
		ld	a,e
		or	d
		ld	(DISPLAY_PALETTE),a
		GET_RND_NUMBERS
		ld	e,a
		ld	a,(ix+$3F)
		cp	e
		jr	c,.skip2
		GET_GAME_VARIABLE $36
		jr	z,.skip2
		push	af
		PRINT_MESSAGE2 $0F
		pop	af
		call	point_ix_to_record
		PRINT_IX_HERO_NAME
		jr	.loop3
.skip:
		call	who_cast_spell
		jr	c,.loop
		ld	a,(current_spell)
		cp	3
		jr	nz,.loop
		call	spend_spell_points
		jr	c,.loop
		jr	.skip5
.skip2:
		PRINT_MESSAGE2 $0B
.loop3:
		CHANGE_SPEED $08
.loop4:
		jr	.loop
.skip3:
		PRINT_MESSAGE2 $0C
		jr	.loop3
.done:
		inc	(iy+$36)
		ret
.skip4:
		ld	a,10
		call	prompt_pick_hero
		jr	c,.loop
		jr	z,.loop
		ld	(iy+$53),b
		PRINT_MESSAGE2 $0E
		call	enter_text
		jr	c,.loop4
		PRINT_MESSAGE2 $1A
		GET_GAME_VARIABLE $36
		jr	z,.skip5
		call	point_ix_to_record
		ld	de,TEXT_BUFFER
		ex	de,hl
.loop5:
		ld	a,(de)
		cp	$FE
		jr	z,.skip5
		cp	(hl)
		jr	nz,.skip6
		inc	hl
		inc	de
		jr	.loop5
.skip5:
		PRINT_MESSAGE2 $0D
		ld	(iy+$36),0
		jr	.loop3
.done2:
		ld	a,9
		call	prompt_pick_hero
		jp	c,.loop
		ld	(iy+$53),b
		GET_GAME_VARIABLE $36
		ret	z
.skip6:
		PRINT_MESSAGE2 $10
		ld	a,(iy+$36)
		call	point_ix_to_record
		PRINT_IX_HERO_NAME
		CHANGE_SPEED $08
		ld	hl,$D6FD
		call	roll_from_daypart_table
		ld	a,(iy+$36)
		cp	3
		jr	c,.skip7
		ld	(iy+$53),6
.skip7:
		ld	b,a
.loop6:
		GET_B_FROM_TABLE $52
		call	set_damage_state
		add	a,15
		call	damage_group_checked
		cp	3
		jr	c,.skip8
		dec	(iy+$53)
		jp	p,.loop6
.skip8:
		ld	(iy+$36),0
		jp	print_stats_table
