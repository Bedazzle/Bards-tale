; --- resolve_spell_effect -------------------------------------
; @done
; Rolls a spell's damage and delivers it. For a hero caster it rolls
; damage once per experience level and accumulates the total; for a
; monster / no active caster it rolls a single amount. It then hands
; off to deliver_spell_hit. The nearby entries (store_dmg_type and
; the spell_state_1/spell_state_4/spell_state_0 helpers) preset VAR_SPELL_STATE and
; VAR_DAMAGE_TYPE before delivering a fixed-effect spell.
; In:  ix = caster; VAR_ACTIVE_HERO selects hero vs monster caster;
;      iy = game variables
resolve_spell_effect:
		GET_GAME_VARIABLE	VAR_ACTIVE_HERO		; ???

		jr	c,spell_roll_damage
		jr	z,spell_roll_damage
		ld	d,(ix+CHAR_LEVEL_HI)
		ld	e,(ix+CHAR_LEVEL_LO)

		RESET_DAMAGE

.roll_loop:
		push	bc

		ROLL_DAMAGE

		pop	bc
		dec	de
		ld	a,d
		or	e
		jr	nz,.roll_loop

		jr	deliver_spell_hit

; -------------------------------------
spell_state_1:
		ld (iy+VAR_SPELL_STATE),1
		jr	store_dmg_type

spell_state_4:
		ld (iy+VAR_SPELL_STATE),4
		jr	store_dmg_type

spell_state_0:
		ld (iy+VAR_SPELL_STATE),0

; --- store_dmg_type -------------------------------------------
; @done
; Shared tail for the spell_state_1/spell_state_4/spell_state_0 fixed-effect
; helpers: stores the damage/element type in VAR_DAMAGE_TYPE, clears
; the damage total (hl=0) and drops into deliver_spell_hit.
; In:  a = damage type
store_dmg_type:
		ld (GAME_VARIABLES + VAR_DAMAGE_TYPE),a
		ld hl,0
		jr	deliver_spell_hit

; -------------------------------------

spell_roll_damage:
		RESET_DAMAGE

		ROLL_DAMAGE

; --- deliver_spell_hit ----------------------------------------
; @done
; Delivers a resolved spell to its target(s). Works out whether the
; target is an enemy or a party member, checks its status/immunity,
; announces the target ("at <name>"), then computes and prints the
; damage ("...for N points of damage"), applies it to the target
; group and prints the closing message. Handles the no-effect, flee
; and plain-melee outcomes.
; In:  hl = damage amount; VAR_DAMAGE_TYPE / VAR_TARGET_ID select the
;      target; iy = game variables
deliver_spell_hit:
		ld	a,(GAME_VARIABLES + VAR_DAMAGE_TYPE)
		push	af

		GET_GAME_VARIABLE	VAR_TARGET_ID		; ???

		jr	nz,.have_target

		GET_GAME_VARIABLE	VAR_ACTIVE_HERO		; ???

		jr	c,.have_target

		ld	a,1
		ld	(ENEMY+ENEMY_ACTIVE_FLAG),a

.have_target:
		GET_GAME_VARIABLE	VAR_TARGET_ID		; ???

		jr	c,.enemy_check

		FIND_HERO_BY_A

		CHECK_HERO_STATUS

		jr	c,.check_status

		cp	3
		jr	nz,.done

		pop	af
		push	af

		cp	5
		jr	z,.announce

.done:
		pop	af

		jp	print_ellipsis

.enemy_check:
		and	$7F

		GET_A_FROM_TABLE	$36

		jr	z,.done

.check_status:
		pop	af
		push	af

		cp	5
		jr	nz,.announce

		bit	7,(iy+VAR_ACTIVE_HERO)
		jr	z,.done

.announce:
		PRINT_MESSAGE	$65			; "at"

		PRINT_ACTOR_NAME

		CHECK_FLEE_RESULT

		jr	c,.do_damage

		or	a
		jr	z,.self_check

		srl	h
		rr	l

		jr	.do_damage

.self_check:
		pop	af
		push	af

		cp	5
		jr	nz,.no_effect

		bit	7,(iy+VAR_ACTIVE_HERO)
		jr	z,.do_damage

.no_effect:
		PRINT_MESSAGE	$6A			; "but it had no effect!"

		pop	af
		and	a

		ret

.do_damage:
		pop	af
		or	a
		jr	nz,.apply_group
		call	get_top3_bits

		PRINT_MESSAGE	$69			; "and"

		ld	a,b
		add	a,$AC

		PRINT_WORD

		PRINT_MESSAGE	$80			; "him for"

		xor	a

		cp	h
		ld	a,l
		jr	z,.dmg_amount

		inc	a

.dmg_amount:
		dec	a
		ld	(GAME_VARIABLES + VAR_DISPLAY_COUNT),a
		ex	de,hl

		PRINT_NUM_FROM_DE

		ex	de,hl

		PRINT_IN_LOOP
		DB $60,$61,$FF			; "point"
									; "of damage"

.apply_group:
		ld	a,(GAME_VARIABLES + VAR_TARGET_ID)
		call	apply_damage_to_group
		jr	c,.melee

		GET_GAME_VARIABLE	VAR_SPELL_STATE		; ???

		jr	z,.blank_msg

		ld	b,a

		GET_GAME_VARIABLE	VAR_ACTIVE_HERO		; ???

		jr	z,.blank_msg

		jr	c,.blank_msg

		ld	a,b
		ld	(iy+VAR_SPELL_STATE),0
		call	print_attack_result

		PRINT_MESSAGE	$62			; "him!"

		ret

.blank_msg:
		PRINT_MESSAGE	$63			; ===empty message===

		ret

.melee:
		ATTACK_AND_RESULT

		PRINT_MESSAGE	$62			; "him!"

		ret
