; --- combat_party -----------------------------------------
; @done
; Enter combat with the ambush flag pre-set, then fall straight
; into combat_foes. Used when the party is caught in (or springs)
; an ambush so the encounter starts already flagged.
; In:  iy = game variables base
combat_party:
		ld	(iy+VAR_AMBUSH_FLAG),1

; -------------------------------------

; --- combat_foes ------------------------------------------
; @done
; Top-level combat entry point. Raise the pause flag, run the
; whole encounter (run_combat) and lower pause again on return.
; Called from the main game cycle and the location / creature
; handlers when a fight begins.
; In:  iy = game variables base
combat_foes:
		inc	(iy+VAR_PAUSE)		; pause ON
		call	run_combat		; combat with enemies
		dec	(iy+VAR_PAUSE)		; pause OFF

		ret

; -------------------------------------

; --- run_combat -------------------------------------------
; @done
; Drive one combat encounter from start to finish: set the combat
; mode, build the enemy groups and initiative, then loop the
; fight/run prompt, every hero's turn and every enemy's turn until
; the party flees, wins, or is wiped out; finally clean up and
; return to the caller's proc.
; In:  iy = game variables base
; Note: large state machine; the branch labels mark the per-turn
;       steps of the round
run_combat:
		ld	a,(GAME_VARIABLES + VAR_SPELL_ACTIVE)
		ld	(GAME_VARIABLES + VAR_COMBAT_MODE),a
		call	clear_spell_active
		call	generate_encounter
		call	encounter
		call	enemy_group_advance

		jr	fight_run_prompt
; -------------------------------------

you_still_face:
		PRINT_MESSAGE	$0D			; "You still face:"

		call	list_enemy_groups
		call	enemy_group_advance

		GET_GAME_VARIABLE	VAR_INITIATIVE_FLAG		; ???

		jr	nz,start_hero_turns

fight_run_prompt:
		call	fight_or_run

		GET_GAME_VARIABLE	VAR_FLEE_SUCCESS		; ???

		jp	nz,combat_cleanup

start_hero_turns:
		PRINT_NEWLINE

		call	calc_combat_initiative
		ld	(iy+VAR_ENEMY_SLOT),$FF

hero_turn_loop:
		ld	b,0

hero_turn_body:
		GET_B_FROM_TABLE	$38

		cp	(iy+VAR_ENEMY_SLOT)
		jp	nz,skip_hero

		exx
		ld	(hl),0
		exx

		FIND_HERO_BY_B

		jr	z,skip_hero

		CHECK_HERO_STATUS

		jr	nc,skip_hero

		ld	a,b
		or	a
		jr	nz,dispatch_hero_action

		GET_ATTR_BY_PARAM_SAVE_HL	CHAR_SPECIAL_FLAG		; ???

		jr	z,ally_choose_action

		GET_GAME_VARIABLE	VAR_ALLY_COUNTER			; ???

		jr	nz,skip_hero

ally_choose_action:
		GET_RND_BY_PARAM	3

		add	a,$11

		GET_A_FROM_TABLE	$37

		jr	z,ally_melee

		cp	$FF
		jr	z,skip_hero

		cp	$4F 	; 'O'
		jr	nc,ally_cast

		GET_A_FROM_TABLE	$35

ally_cast:
		ld	(GAME_VARIABLES + VAR_CURRENT_SPELL),a
		xor	a
		ld	(GAME_VARIABLES + VAR_ACTIVE_HERO),a
		call	enemy_takes_turn
		jr	announce_spell
; -------------------------------------

ally_melee:
		call	enemy_takes_turn
		jp	resolve_attack_target
; -------------------------------------

dispatch_hero_action:
		GET_B_FROM_TABLE	$56

		cp	8
		jr	z,hero_confused_target

		cp	4
		jr	z,hero_cast_action

		cp	6
		jr	z,hero_use_item

		cp	1
		jr	z,hero_melee_action

		cp	3
		jr	nz,skip_hero

		GET_B_FROM_TABLE	$3C

		ld	(GAME_VARIABLES + VAR_CURRENT_SPELL),a

		GET_B_FROM_TABLE	$51

		call	set_target_and_hero

announce_spell:
		PRINT_NEWLINE

		PRINT_IX_HERO_NAME

		ld	a,(GAME_VARIABLES + VAR_CURRENT_SPELL)

		cp	$4F ; 'O'
		jr	c,cast_targeted_spell

		cp	$5A ; 'Z'
		jr	nc,cast_targeted_spell

cast_area_spell:
		call	breath_message
		jr	next_hero_turn
; -------------------------------------

skip_hero:
		jp	advance_hero
; -------------------------------------

cast_targeted_spell:
		call	do_cast_spell
		jr	next_hero_turn
; -------------------------------------

hero_cast_action:
		GET_B_FROM_TABLE	$51

		ld	(GAME_VARIABLES + VAR_CURRENT_SPELL),a

		GET_B_FROM_TABLE	$3B

		call	set_target_and_hero

		GET_B_FROM_TABLE	$3A

		call	use_and_break_item
		call	spell_casting
		jr	c,cast_area_spell
		jr	next_hero_turn
; -------------------------------------

hero_use_item:
		call	process_bard_song
		jr	nc,next_hero_turn

		PRINT_NEWLINE

		CHANGE_COMBAT_SPEED

next_hero_turn:
		jp	hero_turn_loop
; -------------------------------------

hero_confused_target:
		GET_ATTR_BY_PARAM_SAVE_HL	CHAR_STATUS		; get hero status

		cp	STATUS_NUTS
		jr	nz,use_stored_target

		GET_RND_BY_PARAM	1

		jr	resolve_target
; -------------------------------------

use_stored_target:
		ld	a,(ix+CHAR_FORMER_HEALTH)

resolve_target:
		or	a
		jr	z,no_target_check

		PICK_RANDOM_HERO

		jr	set_hero_target
; -------------------------------------

no_target_check:
		IF_FB98_IS_ZERO

		jr	z,skip_hero
		ld	a,$80

		jr	set_hero_target
; -------------------------------------

hero_melee_action:
		GET_B_FROM_TABLE	$51

set_hero_target:
		ld	(GAME_VARIABLES + VAR_TARGET_ID),a
		or	a
		jr	nz,resolve_attack_target
		ld	a,(ENEMY+ENEMY_SPECIAL_FLAG)
		or	a
		jr	nz,resolve_attack_target
		ld	a,1
		ld	(ENEMY+ENEMY_ACTIVE_FLAG),a

resolve_attack_target:
		GET_GAME_VARIABLE	VAR_TARGET_ID			; ???

		jp	c,check_target_alive
		push	ix
		push	bc

		FIND_HERO_BY_A

		pop	bc

		GET_ATTR_BY_PARAM_SAVE_HL	CHAR_STATUS		; get hero status

		pop	ix

		cp	STATUS_DEAD
		jr	c,announce_attack

		cp	STATUS_POSSESSED
		jr	nc,announce_attack
		jr	next_hero_turn
; -------------------------------------

check_target_alive:
		and	$7F
		ld	c,a

		GET_C_FROM_TABLE	$36

		jr	z,next_hero_turn

announce_attack:
		PRINT_NEWLINE

		PRINT_IX_HERO_NAME

		ld	a,b
		or	a
		jr	nz,test_chop

		ld	a,(ENEMY+ENEMY_ATTACK_SPEC)
		call	print_attack_word

		jr	test_is_missed
; -------------------------------------

test_chop:
		ld	e,1
		call	find_equipped_by_type
		jr	nc,test_swing

		PRINT_MESSAGE	$5D			; "chops"

		PRINT_MESSAGE	$65			; "at"

		jr	test_is_missed
; -------------------------------------

test_swing:
		PRINT_MESSAGE	$5E			; "swings"

		PRINT_MESSAGE	$65			; "at"

test_is_missed:
		PRINT_ACTOR_NAME

		call	calc_attack_damage
		jr	nc,multi_hit

		PRINT_MESSAGE	$37			; "but misses!"

		jr	after_hero_attack
; -------------------------------------

multi_hit:
		GET_ATTR_BY_PARAM_SAVE_HL	CHAR_ATT_ROUND

		jr	z,single_hit
		push	af

		PRINT_IN_LOOP
		DB $36,$4E,$FF			; "and"
									; "hits"

		pop	af

		PRINT_NEXT_DIGIT

		PRINT_MESSAGE	$53			; "times for"

		jr	apply_hit_damage
; -------------------------------------

single_hit:
		PRINT_IN_LOOP
		DB $36,$4F,$FF			; "and"
									; "hits for"

apply_hit_damage:
		SHOW_DAMAGE

		jr	c,resolve_damage

		GET_GAME_VARIABLE	VAR_DAMAGE_TYPE		; ???

		jr	nz,resolve_damage

		PRINT_MESSAGE	$63			; ===empty message===

		jr	after_hero_attack
; -------------------------------------

resolve_damage:
		ATTACK_AND_RESULT

		PRINT_MESSAGE	$62			; "him!"

after_hero_attack:
		PRINT_NEWLINE

		push	de

		PRINT_STATS_TABLE

		pop	de

		CHECK_ALL_HEROES

		jp	c,oh_dear_game_over

		CHANGE_COMBAT_SPEED

		jp	hero_turn_loop
; -------------------------------------

advance_hero:
		inc	b
		ld	a,b
		cp	7
		jp	nz,hero_turn_body
		ld	b,0

enemy_turn_loop:
		ld	(iy+VAR_ACTIVE_ENEMY),b

		GET_B_FROM_TABLE	$36

		jr	z,next_enemy

		ld	c,a

		GET_B_FROM_TABLE	$57

		jr	nz,next_enemy

		CALC_SPELL_FX

		ld	e,0

find_enemy_target:
		ld	a,(hl)
		cp	(iy+VAR_ENEMY_SLOT)
		jp	z,enemy_attack
		inc	hl
		inc	e
		ld	a,e
		cp	c
		jr	c,find_enemy_target

next_enemy:
		inc	b
		ld	a,b
		cp	4
		jr	c,enemy_turn_loop
		dec	(iy+VAR_ENEMY_SLOT)
		jp	nz,hero_turn_loop
		ld	b,3

enemy_action_loop:
		GET_B_FROM_TABLE	1

		GET_B_FROM_LIST	$57

		xor	a

		GET_B_FROM_LIST	1

		dec	b
		jp	p,enemy_action_loop

		call	party_disbelieve
		ld	a,(ENEMY)
		or	a
		jr	z,end_of_round

		ld	a,(ENEMY+ENEMY_SPECIAL_FLAG)
		or	a
		jr	z,end_of_round

		GET_GAME_VARIABLE	VAR_ALLY_COUNTER

		jr	nz,end_of_round
		ld	(iy+VAR_ACTIVE_HERO),1
		ld	(iy+VAR_TARGET_ID),$80

		CHECK_FLEE_RESULT

		jr	c,end_of_round

		inc	(iy+VAR_ALLY_COUNTER)

		PRINT_MESSAGE	$0E			; "Your foes see through your illusion!"

		CHANGE_COMBAT_SPEED

end_of_round:
		call	process_poison
		call	regen_equipped_effects
		call	post_combat_cleanup
		push	af

		PRINT_STATS_TABLE

		pop	af
		jp	c,oh_dear_game_over

		CHECK_THREE_HEROES

		jr	nc,continue_combat

		FIND_ALIVE_HERO

		jr	c,continue_combat

		GET_GAME_VARIABLE	VAR_AMBUSH_FLAG		; ???

		jr	z,foes_defeated

		PRINT_MESSAGE	$0F			; "Do you wish to continue?"

		PRINT_YES_NO_WAIT

		push	af

		PRINT_NEWLINE

		pop	af
		jr	c,continue_combat
		jr	combat_cleanup
; -------------------------------------

foes_defeated:
		call	enemies_killed

combat_cleanup:
		ZERO_BUFFERS

		CLEAR_INFO_PANEL

		xor	a
		ld	(GAME_VARIABLES + VAR_AMBUSH_FLAG),a
		ld	(GAME_VARIABLES + VAR_ENCOUNTER_CTR),a
		ld	a,(ENEMY+ENEMY_ATTACK_SPEC)
		or	a
		jr	nz,restore_after_combat

		CLEAN_ALLY_MEMORY

restore_after_combat:
		GET_GAME_VARIABLE	VAR_COMBAT_MODE			; ???

		jr	z,combat_return
		ld	a,(GAME_VARIABLES + VAR_SPELL_ID)
		call	start_spell_or_song

combat_return:
		jp	recalc_party_ac
; -------------------------------------

continue_combat:
		jp	you_still_face
; -------------------------------------

enemy_attack:
		push	bc
		ld	(hl),0

		GET_RND_BY_PARAM	3

		ld	c,a
		ld	d,4
		call	pick_random_hero_lo
		ld	(GAME_VARIABLES + VAR_TARGET_ID),a
		push	bc
		push	ix

		FIND_HERO_BY_A

		CHECK_HERO_STATUS

		pop	ix
		pop	bc
		jr	nc,enemy_turn_done

enemy_pick_spell:
		ld	h,0

		GET_B_FROM_TABLE	$41

		ld	l,a
		add	hl,hl
		add	hl,hl
		push	bc
		ld	b,0
		add	hl,bc
		ld	b,h
		ld	c,l
		call	show_monster_magic
		pop	bc
		jr	z,enemy_retry_spell

		cp	$4F
		jr	nc,enemy_cast_setup

		GET_A_FROM_TABLE	$35

enemy_cast_setup:
		ld	(GAME_VARIABLES + VAR_CURRENT_SPELL),a
		push	af
		ld	a,b
		or	$80
		ld	(GAME_VARIABLES + VAR_ACTIVE_HERO),a

		PRINT_NEWLINE

		call	set_combat_target
		pop	af

		cp	$4F
		jr	nc,enemy_area_spell

		call	do_cast_spell

		PRINT_NEWLINE

enemy_turn_done:
		jr	next_enemy_turn
; -------------------------------------

enemy_area_spell:
		cp	$FE
		jr	z,enemy_special

		call	breath_message

		PRINT_NEWLINE

		jr	next_enemy_turn
; -------------------------------------

enemy_special:
		call	enemy_joins_party
		jr	c,enemy_attack_hero

		PRINT_NEWLINE

		jr	next_enemy_turn
; -------------------------------------

enemy_retry_spell:
		ld	a,b

		cp	2
		jr	c,enemy_melee

		inc	c
		ld	a,c
		and	3
		ld	c,a
		dec	d
		jr	nz,enemy_pick_spell
		jr	next_enemy_turn
; -------------------------------------

enemy_melee:
		PRINT_NEWLINE

		PRINT_MESSAGE	$10			; "A"

		call	set_combat_target

enemy_attack_hero:
		GET_B_FROM_TABLE	$41

		call	print_attack_word
		ld	a,(GAME_VARIABLES + VAR_TARGET_ID)

		PRINT_ACTOR_NAME

		call	calc_enemy_attack
		jr	nc,enemy_hit

		PRINT_MESSAGE	$37			; "but misses!"

		jr	after_enemy_attack

enemy_hit:
		PRINT_IN_LOOP
		DB $36,$4F,$FF			; "and"
									; "hits for"

		SHOW_DAMAGE

		jr	nc,enemy_hit_nodmg

		ATTACK_AND_RESULT

		PRINT_MESSAGE	$62			; "him!"

		jr	after_enemy_attack

enemy_hit_nodmg:
		PRINT_MESSAGE	$63			; ===empty message===

after_enemy_attack:
		PRINT_STATS_TABLE

		CHECK_ALL_HEROES

		jp	c,oh_dear_game_over

		CHANGE_COMBAT_SPEED

next_enemy_turn:
		pop	bc
		jp	enemy_turn_loop

; --- print_attack_word ------------------------------------
; @done
; Pick and print a random combat attack word for the attacker,
; then (unless the word stands on its own) append ' at'. Emits a
; leading space.
; In:  a = attack-type index
; Out: attack word printed; a = selected word id
; Note: word ids 7, $0A and $0D print with no trailing 'at'
print_attack_word:
		push	af

		PRINT_SPACE

		GET_RND_BY_PARAM	1

		ld	c,a
		pop	af

		GET_A_FROM_TABLE	$74

		add	a,a
		add	a,c
		push	af
		add	a,$94 		; '”'

		PRINT_WORD

		pop	af

		cp	7
		ret	z

		cp	$0A
		ret	z

		cp	$0D
		ret	z

		PRINT_SPACE

		PRINT_MESSAGE	$65			; "at"

		ret
; -------------------------------------

; --- enemy_takes_turn ---------------------------------------------
; @done
; Set a default combat target: mark the target id as $80, and if
; an enemy is currently active pick a random party member as the
; concrete target instead.
; In:  iy = game variables base
; Out: VAR_TARGET_ID set
enemy_takes_turn:
		ld	(iy+VAR_TARGET_ID),$80
		ld	a,(ENEMY+ENEMY_ACTIVE_FLAG)
		or	a
		ret	z

		PICK_RANDOM_HERO

		ld	(GAME_VARIABLES + VAR_TARGET_ID),a

		ret

; -------------------------------------

; --- set_target_and_hero ----------------------------------
; @done
; Store the current target id and active-hero index into the
; combat game variables.
; In:  a = target id, b = active hero index, iy = game variables
; Out: VAR_TARGET_ID and VAR_ACTIVE_HERO updated
set_target_and_hero:
		ld	(GAME_VARIABLES + VAR_TARGET_ID),a
		ld	(iy+VAR_ACTIVE_HERO),b

		ret

; -------------------------------------

; --- set_combat_target ---------------------------------------------
; @done
; Reset the display counter and print the name word of enemy group
; b (word id from table $41), tail-calling print_word.
; In:  b = enemy group index
set_combat_target:
		xor	a
		ld	(GAME_VARIABLES + VAR_DISPLAY_COUNT),a

		GET_B_FROM_TABLE	$41

		jp	print_word
