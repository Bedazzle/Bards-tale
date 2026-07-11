; --- do_advancement -----------------------------------------
; @done
; Review-Board "Advancement" option: raise the chosen hero one
; experience level. Prompts for a party member and checks they
; have enough XP for the next level (calc_xp_for_level); if not,
; reports how much more is needed. On success it bumps the level
; (and max-level) counters, restores any backed-up params, rerolls
; hit points and - for spellcasters - spell points, applies the
; class-specific gains (Rogue/Hunter skills, warrior attacks per
; round) and a random +1 to one stat, then loops back to the menu.
; In:  called from proc_reviewbord; ix = hero record (via enter_hero_num), iy = game vars
; Note: all paths converge on the not_enough_exp.done tail (recompute AC, print, re-prompt).
do_advancement:
		CLEAR_INFO_PANEL

		PRINT2_IN_LOOP
		DB $0B,$69,$0F,$FF		; "The Guild leaders"
									; "prepare to weigh thy merits."
									; "Who shall be reviewed?"

		PRINT_MESSAGE	$44			; "(1-6)"

		call	enter_hero_num
		jr	c,reset_reviewboard

		CHECK_HERO_STATUS

		jr	nc,reset_reviewboard

		CLEAR_INFO_PANEL

		PRINT2_IN_LOOP
		DB $0B,$68,$FF			; "The Guild leaders"
									; "deem that"

		PRINT_IX_HERO_NAME

		GET_ATTR_BY_PARAM	CHAR_LEVEL_HI

		inc	hl
		ld	l,(hl)
		ld	h,a
		call	calc_xp_for_level
		jr	nc,increase_char_level

not_enough_exp:
		PRINT_MESSAGE2	$6C			; "still needeth"

		ld	e,CHAR_EXP_START
		call	get_attr_param
		call	print_large_number

		PRINT_MESSAGE2	$6D			; "experience points prior to advancement."

.done:
		call	calc_armor_class			; recompute armour class after the change

		PRINT_AND_WAIT

		jr	do_advancement
; -------------------------------------

increase_char_level:
		PRINT_MESSAGE2	$6B			; "hath earned a level of advancement..."

		FIND_ATTR_AND_ADDRESS	CHAR_LEVEL_LO

		inc	(hl)
		dec	hl
		jr	nz,.bump_maxlevel

		inc	(hl)

.bump_maxlevel:
		dec	hl
		inc	(hl)
		dec	hl
		jr	nz,.roll_gains

		inc	(hl)

.roll_gains:
		call	compare_char_attrs
		call	z,copy_char_params
		call	unpack_hero_attrs
		ld	b,(ix+CHAR_CLASS)

		GET_B_FROM_TABLE	$0E

		ld	b,a

		GET_RND_NUMBERS

		and	b
		ld	b,a
		ld	a,(byte_FB5D)
		call	adjust_stat_floor

		FIND_ATTR_AND_ADDRESS	CHAR_COND_LO

		call	add_16bit_carry

		GET_ATTR_BY_PARAM_SAVE_HL	CHAR_CLASS		; get hero class

		jr	z,roll_level_gains

		cp	CLASS_ROGUE
		jr	z,.rogue_skills
		jr	nc,roll_level_gains

		GET_RND_BY_PARAM	3

		ld	b,a
		ld	a,(byte_FB5D)
		call	adjust_stat_floor

		FIND_ATTR_AND_ADDRESS	CHAR_SPPT_LO

		call	add_16bit_carry

		jr	roll_level_gains.roll_stat
; -------------------------------------

.rogue_skills:
		ld	b,3

		FIND_ATTR_AND_ADDRESS	CHAR_ROGUE_DISARM

.skill_loop:
		ld	a,(byte_FB5E)
		sub	$0E
		jr	nc,.skill_base

		xor	a

.skill_base:
		ld	e,a

		GET_RND_BY_PARAM	7

		add	a,e
		add	a,(hl)
		jr	nc,.store_skill

		ld	a,$FF

.store_skill:
		ld	(hl),a
		inc	hl
		djnz	.skill_loop

		jr	roll_level_gains.roll_stat
; -------------------------------------
roll_level_gains:
		cp	8
		jr	nz,.check_melee_classes

		FIND_ATTR_AND_ADDRESS	CHAR_HUNTER_CHANCE

		ld	b,1

		jr	increase_char_level.skill_loop
; -------------------------------------

.check_melee_classes:
		cp	0
		jr	z,.set_attacks

		cp	7
		jr	z,.set_attacks

		cp	9
		jr	nz,.roll_stat

.set_attacks:
		GET_ATTR_BY_PARAM	CHAR_LEVEL_HI

		jr	nz,.cap_attacks

		inc	hl
		ld	a,(hl)
		dec	a
		srl	a
		srl	a

		cp	8
		jr	c,.store_attacks

.cap_attacks:
		ld	a,7

.store_attacks:
		ld	(ix+CHAR_ATT_ROUND),a

.roll_stat:
		GET_RND_BY_PARAM	7

		cp	5
		jr	c,.stat_index

		sub	5

.stat_index:
		ld	e,a
		ld	b,5

.find_stat:
		GET_E_FROM_TABLE	$48

		cp	$12
		jr	c,.raise_stat

		inc	e
		ld	a,e

		cp	5
		jr	c,.next_stat

		ld	e,0

.next_stat:
		djnz	.find_stat

		jp	not_enough_exp.done
; -------------------------------------

.raise_stat:
		exx
		inc	(hl)
		exx

		PRINT_MESSAGE2	$6E			; "+1 to"

		ld	a,e
		add	a,$80

		PRINT2_A_WITH_FLAG_0

		call	pack_hero_attrs

		jp	not_enough_exp.done
