; --- enemies_killed -----------------------------------------
; @done
; Post-combat victory / spoils sequence. Runs any post-combat hook,
; shows the "Treasure!" screen, then rolls the gold and experience
; won (accumulated over several random draws from the encounter
; tables), awards them to every character, and hands out any item
; treasures to randomly chosen living heroes.
; In:  iy = game variables
; Note: gold/xp/item amounts derive from the encounter's random
;       tables; distribution details partially inferred.
enemies_killed:
		CHANGE_COMBAT_SPEED

		xor	a
		ld	(GAME_VARIABLES + VAR_TREASURE_FLAG),a

		cp	(iy+VAR_UNDERGROUND)
		jr	z,collect_loot

		cp	(iy+VAR_AREA_MODE)
		jr	z,collect_loot

		ld	a,9
		call	hook_postcombat

collect_loot:
		ld	b,$92			; text: Treasure!
		ld	a,PIC_GRAVE

		SHOW_NAME_PIC_AB

		call	nullify_FDDD
		ld	l,a
		ld	h,a
		ld	(GAME_VARIABLES + VAR_XP_TOTAL_HI),hl
		ld	(GAME_VARIABLES + VAR_TREASURE_HI),hl
		ld	(GAME_VARIABLES + VAR_INFO_ROW_POS),a
		ld	(GAME_VARIABLES + VAR_TREASURE_LO),a
		ld	b,$0F

.gold_roll_loop:
		GET_RND_NUMBERS

		GET_IY_A_FROM_TABLE	$54,$28

		and	(iy+VAR_RND_LO)
		ld	h,a
		jr	nz,.roll_gold_hi

		ld	a,(GAME_VARIABLES + VAR_RND_HI)
		or	7
		ld	(GAME_VARIABLES + VAR_RND_HI),a

.roll_gold_hi:
		GET_IY_A_FROM_TABLE	$54,$29

		and	(iy+VAR_RND_HI)
		ld	l,a
		ld	(GAME_VARIABLES + VAR_GOLD_FOUND_HI),hl

		GET_B_FROM_TABLE	$2B

		jr	z,.next_roll

		ld	c,a

		GET_C_FROM_TABLE	INX_XP_TABLE

		ld	e,a
		ld	a,c

		cp	$10
		jr	nc,.xp_hi

		ld	d,0

		jr	.check_count
; -------------------------------------

.xp_hi:
		ld	d,e
		ld	e,0

.check_count:
		GET_B_FROM_TABLE	$2A

		jr	z,.next_roll

		ld	c,a
		ld	hl,(GAME_VARIABLES + VAR_TREASURE_HI)

.accum_loop:
		push	de

		GET_RND_BY_PARAM	7

		jr	nz,.add_treasure

		inc	(iy+VAR_INFO_ROW_POS)

.add_treasure:
		add	hl,de
		jr	nc,.maybe_add_xp

		inc	(iy+VAR_TREASURE_LO)

.maybe_add_xp:
		GET_GAME_VARIABLE	VAR_TREASURE_FLAG		; ???

		jr	nz,.accum_next

		push	hl
		ld	hl,(GAME_VARIABLES + VAR_GOLD_FOUND_HI)
		ld	de,(GAME_VARIABLES + VAR_XP_TOTAL_HI)
		add	hl,de
		ld	(GAME_VARIABLES + VAR_XP_TOTAL_HI),hl
		pop	hl

.accum_next:
		pop	de
		dec	c
		jr	nz,.accum_loop

		ld	(GAME_VARIABLES + VAR_TREASURE_HI),hl

.next_roll:
		dec	b
		jp	p,.gold_roll_loop

		CLEAR_INFO_PANEL


		PRINT_MESSAGE	$2A			; "Each character receives"

		ld	a,$14
		call	award_experience
		call	print_large_number

		PRINT_MESSAGE	$78			; "experience points for valor and battle knowledge,"

		PRINT_MESSAGE	$69			; "and"

		ld	hl,(GAME_VARIABLES + VAR_XP_TOTAL_HI)
		ld	a,l

		cp	$0E
		jr	nc,.award_gold

		ld	l,$0E

.award_gold:
		ld	a,$24
		call	award_experience
		call	print_large_number

		PRINT_MESSAGE	$79			; "pieces of gold."

		GET_GAME_VARIABLE	VAR_TREASURE_FLAG		; ???

		jr	nz,no_more_loot

		GET_GAME_VARIABLE	VAR_INFO_ROW_POS

		ld	c,a
		ld	a,(iy+VAR_COPY_DAYPART)
		jr	nz,.calc_item_count

		cp	4
		jr	c,.calc_item_count

		inc	c

.calc_item_count:
		add	a,$FC
		ld	a,1
		adc	a,0

		cp	c
		jr	nc,.give_item_loop

		ld	c,a

.give_item_loop:
		dec	c
		inc	c
		jr	z,no_more_loot

		CHANGE_SPEED $0F

		GET_RND_NUMBERS

		ld	b,a

		GET_IY_A_FROM_TABLE	$54,$4F

		and	b
		ld	b,a

		GET_IY_A_FROM_TABLE	$54,$50

		add	a,b
		jr	nz,.have_item

		inc	a

.have_item:
		ld	e,a

		GET_RND_BY_PARAM	7

		cp	7
		ld	d,0
		jr	nz,.pick_hero

		ld	d,$F0

.pick_hero:
		PICK_RANDOM_HERO

		or	a
		jr	z,.pick_hero

		FIND_HERO_BY_A

		ld	h,6

.try_give:
		ld	a,b
		call	add_item_to_hero
		jr	nc,treasure_found

.next_recipient:
		dec	h
		jr	z,no_more_loot

		dec	b
		jr	nz,.wrap_hero

		ld	b,6

.wrap_hero:
		FIND_HERO_BY_B

		CHECK_HERO_STATUS

		jr	c,.try_give

		jr	.next_recipient
; -------------------------------------

treasure_found:
		PRINT_NEWLINE

		PRINT_IX_HERO_NAME

		PRINT_MESSAGE	$7A			; "found a"

		PRINT_SPACE

		ld	a,d
		add	a,a
		ld	a,e
		jr	nc,.print_item

		GET_E_FROM_TABLE	INX_ITEM_SPECATT

		and	$0F
		or	$80

.print_item:
		PRINT_ITEM_NAME

		PRINT_MESSAGE	$63			; ===empty message===

		dec	c

		jr	collect_loot.give_item_loop
; -------------------------------------

no_more_loot:
		CHANGE_SPEED $19

		ret
