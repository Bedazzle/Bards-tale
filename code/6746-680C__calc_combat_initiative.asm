; --- calc_combat_initiative (calc_combat_initiative) ------------------------
; @done
; Compute this round's initiative/speed value for every combatant. Per
; hero: derive a base from won-combats and the speed stat, add a random
; amount, apply a class modifier (rogue/paladin/monk/other) and clamp to
; 1..$FF. Then set the ally leader's speed and each enemy group's speed
; the same way. If VAR_INITIATIVE_FLAG is set the heroes' slots are just
; zeroed (surprise round).
; In:  iy = game variables base
; Note: writes the FDD1/FDD6 initiative buffers.
calc_combat_initiative:
		GET_GAME_VARIABLE	VAR_INITIATIVE_FLAG			; ???

		jr	z,.calc_heroes

		ld	hl,___table_9G+$6
		ld	b,7
		call	nullify_buffer
		ld	(GAME_VARIABLES + VAR_INITIATIVE_FLAG),a

		jr	.calc_enemies

.calc_heroes:
		ld	b,1
		ld	hl,___table_9G+$1

.hero_loop:
		FIND_HERO_BY_B

		jr	z,.calc_enemies

		GET_ATTR_BY_PARAM_SAVE_HL	CHAR_WON_COMBATS_HI

		srl	a
		ld	c,a

		GET_ATTR_BY_PARAM_SAVE_HL	CHAR_PARAMS_LO

		and	$1F
		sub	$0E
		jr	c,.roll_speed

		rla
		rla
		rla
		and	$F8
		add	a,c
		jr	c,.cap_max

		ld	c,a

.roll_speed:
		GET_RND_BY_PARAM	$1F

		add	a,c
		jr	c,.cap_max

		push	hl

		GET_ATTR_BY_PARAM	CHAR_LEVEL_HI

		srl	a
		ld	d,a
		inc	hl
		ld	a,(hl)
		pop	hl
		rra
		ld	e,a
		ld	a,d
		or	a
		jr	nz,.small_speed

		ld	a,e

		cp	$41 ; 'A'
		jr	nc,.by_class

.small_speed:
		ld	de,$40

.by_class:
		GET_ATTR_BY_PARAM_SAVE_HL	CHAR_CLASS

		jr	z,.finish_hero

		cp	CLASS_ROGUE
		jr	c,.rogue_speed

		cp	CLASS_PALADIN
		jr	c,.paladin_speed

		cp	CLASS_MONK
		jr	c,.finish_hero

		sla	e
		jr	.finish_hero

.rogue_speed:
		srl	e
		srl	e

		jr	.finish_hero

.paladin_speed:
		srl	e

.finish_hero:
		ld	a,e
		add	a,c
		jr	nc,.clamp_min

.cap_max:
		ld	a,$FF

.clamp_min:
		or	a
		jr	nz,.write_speed

		inc	a

.write_speed:
		ld	(hl),a
		inc	hl
		inc	b
		ld	a,b

		cp	7
		jr	c,.hero_loop

.calc_enemies:
		ld	a,(ENEMY+ENEMY_ALIVE)
		or	a
		jr	z,.enemy_groups

		ld	a,(ENEMY+ENEMY_SPEED)
		and	$1F
		add	a,a
		add	a,a
		ld	c,a

		GET_RND_BY_PARAM	$1F

		add	a,c
		jr	nc,.store_ally

		ld	a,$FF

.store_ally:
		ld	(ALLY_DATA+$51),a

.enemy_groups:
		ld	b,0

.group_loop:
		GET_B_FROM_TABLE	$41

		jr	z,.next_group

		CHECK_ITEM_MASK	$70,$1F

		add	a,a
		add	a,a
		ld	c,a

		CALC_SPELL_FX

		GET_B_FROM_TABLE	$36

		jr	z,.next_group

		ld	e,a

.fill_loop:
		GET_RND_BY_PARAM	$1F

		add	a,c
		jr	nc,.write_enemy

		ld	a,$FF

.write_enemy:
		ld	(hl),a
		dec	e
		inc	hl
		jr	nz,.fill_loop

.next_group:
		ld	a,b

		cp	4
		ret	nc

		cp	(iy+VAR_ENEMY_COUNT)
		ret	nc

		inc	b

		jr	.group_loop
