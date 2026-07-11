; --- calc_attack_damage --------------------------------------
; @done
; Resolves one attack from start to finish. First it works out the
; defender's effective armour class - a hero's natural AC, or a
; monster's AC read from the monster tables. Then it builds the
; attacker's to-hit total from class, strength/weapon bonuses, the
; party damage penalty and the enemy AC modifier, and rolls 2x d7 +
; level bonus against it to decide hit or miss. On a hit it rolls the
; damage dice for the weapon (or bare-hand / monk / special-attack
; source), once per attack in CHAR_ATT_ROUND, adds base damage and
; per-target modifiers, subtracts the enemy AC modifier (clamped to a
; minimum of 1), and sets VAR_DAMAGE_TYPE - including the Hunter class
; instant-kill chance.
; In:  iy = game variables base, ix = attacker record,
;      a / VAR_TARGET_ID = defender
; Out: carry set = miss; carry clear = hit with hl = damage dealt and
;      VAR_DAMAGE_TYPE set
calc_attack_damage:
		push	ix
		xor	a
		ld	(GAME_VARIABLES + VAR_DAMAGE_TYPE),a

		GET_GAME_VARIABLE	VAR_TARGET_ID			; ???

		jr	c,.target_monster

		FIND_HERO_BY_A

		ld	a,(ix+CHAR_NATURAL_AC)

		jr	.have_ac

.target_monster:
		and	$7F
		ld	c,a

		GET_C_FROM_TABLE	$2E

		ld	e,a

		GET_C_FROM_TABLE	$41

		GET_A_FROM_TABLE	INX_MONST_HP_AC

		sub	e
		jr	nc,.have_ac

		xor	a

.have_ac:
		pop	ix
		ex	af,af'

		GET_ATTR_BY_PARAM_SAVE_HL	CHAR_POS_IN_PARTY

		ld	(GAME_VARIABLES + VAR_ATTACK_MODIFIER),a
		jr	nz,.hero_attacker

		ld	c,a

		jr	.to_hit
; -------------------------------------

.hero_attacker:
		ld	a,(ix+CHAR_PARAMS_HI)
		call	divide_A_by_8
		sub	$0F
		jr	nc,.str_bonus

		xor	a

.str_bonus:
		ld	c,a
		xor	a
		ld	(GAME_VARIABLES + VAR_WEAPON_BONUS),a
		ld	e,1
		call	find_equipped_by_type
		jr	c,.to_hit

		inc	(iy+VAR_WEAPON_BONUS)

		GET_D_FROM_TABLE	INX_WEAPON_BONUS

		call	divide_A_by_16
		ld	e,a
		add	a,c
		ld	c,a

		GET_D_FROM_TABLE	INX_ITEM_SPECATT

		call	divide_A_by_16
		ld	(GAME_VARIABLES + VAR_DAMAGE_TYPE),a
		ex	af,af'
		sub	e
		jr	nc,.clamp_ac

		xor	a

.clamp_ac:
		ex	af,af'

.to_hit:
		ld	a,(ix+CHAR_CLASS)

		GET_A_FROM_TABLE	$4C

		ld	e,a
		ex	af,af'
		sub	e
		jr	c,.miss_floor

		sub	(iy+VAR_DAMAGE_PENALTY)
		jr	nc,.add_ac_mod

.miss_floor:
		xor	a

.add_ac_mod:
		add	a,(iy+VAR_AC_MOD_ENEMY)

		cp	$15
		jr	c,.roll_hit

		ld	a,$15

.roll_hit:
		ld	e,a

		GET_RND_BY_PARAM	7

		ld	d,a

		GET_RND_BY_PARAM	7

		add	a,d
		add	a,3
		ld	d,a

		GET_IY_A_FROM_TABLE	$6D,$2F

		add	a,d

		cp	e
		ret	c

		GET_GAME_VARIABLE	VAR_ATTACK_MODIFIER			; ???

		jr	nz,.weapon_attack
		ld	a,(ix+CHAR_ATTACK_SPEC)
		ld	b,a
		rlca
		rlca
		rlca
		and	7
		ld	(GAME_VARIABLES + VAR_DAMAGE_TYPE),a
		ld	a,b
		and	$1F
		or	$20 ; ' '

		jr	.roll_damage
; -------------------------------------

.weapon_attack:
		ld	e,1
		call	find_equipped_by_type
		jr	nc,.weapon_dmg

		ld	a,(ix+CHAR_CLASS)

		cp	CLASS_MONK
		jr	nz,.barehand_zero

		GET_ATTR_BY_PARAM	CHAR_LEVEL_HI

		jr	nz,.monk_cap

		inc	hl
		ld	a,(hl)
		srl	a

		cp	$20 ; ' '
		jr	c,.monk_dmg

.monk_cap:
		ld	a,$1F

.monk_dmg:
		GET_A_FROM_TABLE	$6C

		jr	.roll_damage

.barehand_zero:
		xor	a

		jr	.roll_damage
; -------------------------------------

.weapon_dmg:
		GET_D_FROM_TABLE	INX_WEAPON_DAMAGE

.roll_damage:
		push	af
		rlca
		rlca
		rlca
		and	7
		ld	b,a
		pop	af
		and	$1F
		ld	e,a
		inc	e
		ld	a,c
		ex	af,af'

		GET_B_FROM_TABLE	$4D

		ld	c,a
		ld	hl,0
		ld	d,(ix+CHAR_ATT_ROUND)

.attack_round:
		ld	b,e
		push	de

.roll_dice:
		GET_RND_NUMBERS

		and	c
		ld	d,0
		ld	e,a
		scf
		adc	hl,de
		djnz	.roll_dice

		ex	af,af'
		ld	e,a
		add	hl,de
		ld	e,(iy+VAR_BASE_DAMAGE)
		add	hl,de

		GET_IY_A_FROM_TABLE	$6D,$30

		ld	e,a
		add	hl,de

		GET_IY_A_FROM_TABLE	$6D,$2F

		jr	z,.apply_ac

		ld	b,a

.bonus_dice:
		GET_RND_BY_PARAM	7

		ld	e,a
		inc	e
		add	hl,de
		djnz	.bonus_dice

.apply_ac:
		ld	e,(iy+VAR_AC_MOD_ENEMY)
		and	a
		sbc	hl,de
		jr	nc,.store_damage
		ld	hl,1

.store_damage:
		pop	de
		dec	d
		jp	p,.attack_round

		ld	a,(ix+CHAR_CLASS)

		cp	CLASS_HUNTER
		jr	nz,.done

		GET_RND_NUMBERS

		cp	(ix+CHAR_HUNTER_CHANCE)
		jr	nc,.done

		ld	(iy+VAR_DAMAGE_TYPE),7

.done:
		and	a

		ret
