; --- calc_defense_rating ------------------------------------
; @done
; Computes a combatant's defence/agility rating used by the flee check.
; For an enemy (a=0) it derives the rating from the monster's attack
; spec / 8 plus VAR_DEFENSE_BONUS. For a hero it takes level/2 capped at
; $12, adds the defence bonus and a +2 if unarmed, then a class-based
; term from table $3D (Paladin, indexed by level/2 capped $0F) or table
; $3E (other classes), plus the low 3 bits of CHAR_SPEED. Finally adds a
; 0-7 RNG jitter and +1.
; In:  a = 0 for enemy, else hero slot; iy = game variables base
; Out: a = defence rating
; Note: exact rating formula partially inferred from the table lookups.
calc_defense_rating:
		or	a
		jr	nz,.for_hero

		ld	a,(ENEMY+ENEMY_ATTACK_SPEC)
		call	divide_A_by_8
		add	a,(iy+VAR_DEFENSE_BONUS)

		jr	.finish

.for_hero:
		ld	c,a

		FIND_HERO_BY_A

		GET_ATTR_BY_PARAM	CHAR_LEVEL_HI

		jr	nz,.cap_level

		inc	hl
		ld	a,(hl)
		srl	a

		cp	$12
		jr	c,.level_ok

.cap_level:
		ld	a,$12

.level_ok:
		add	a,(iy+VAR_DEFENSE_BONUS)
		ld	d,a
		ld	a,c
		ld	c,0

		CHECK_EQUIPPED	6

		jr	c,.check_class
		ld	c,2

.check_class:
		GET_ATTR_BY_PARAM_SAVE_HL	CHAR_CLASS

		cp	CLASS_PALADIN
		jr	nz,.class_lookup

		GET_ATTR_BY_PARAM_SAVE_HL	CHAR_LEVEL_LO

		srl	a

		cp	$10
		jr	c,.paladin_lookup

		ld	a,$0F

.paladin_lookup:
		GET_A_FROM_TABLE	$3D

		jr	.add_bonus

.class_lookup:
		GET_A_FROM_TABLE	$3E

.add_bonus:
		add	a,d
		ld	d,a

		GET_ATTR_BY_PARAM_SAVE_HL	CHAR_SPEED		; ???

		and	7
		add	a,d
		add	a,c

.finish:
		ld	c,a

		GET_RND_BY_PARAM	7

		add	a,c
		inc	a

		ret
