; --- calc_enemy_attack --------------------------------------
; @done
; Resolve one enemy's attack roll against the current target hero
; (VAR_TARGET_ID). Adds the enemy's attack modifier to the hero's
; natural armour class (clamped to 21), rolls to-hit and, on a hit,
; accumulates the damage total and records the damage/effect type
; in VAR_DAMAGE_TYPE.
; In:  iy = game variables; VAR_TARGET_ID = defending hero,
;      VAR_ACTIVE_ENEMY = attacking enemy slot
; Out: cf set = miss; cf clear = hit, hl = damage amount,
;      VAR_DAMAGE_TYPE = effect type (0..7)
; Note: the effective to-hit AC total is clamped to 21 ($15).
calc_enemy_attack:
		xor	a
		ld	(GAME_VARIABLES + VAR_DAMAGE_TYPE),a
		ld	a,(GAME_VARIABLES + VAR_TARGET_ID)

		FIND_HERO_BY_A

		ld	c,(ix+CHAR_NATURAL_AC)
		ld	e,(iy+VAR_ACTIVE_ENEMY)

		GET_E_FROM_TABLE	$2D

		add	a,c

		cp	$15
		jr	c,.ac_capped

		ld	a,$15

.ac_capped:
		ld	c,a

		GET_E_FROM_TABLE	$41

		GET_A_FROM_TABLE	INX_MONST_SPEC

		ld	l,a
		and	$1F
		ld	b,a
		inc	b
		srl	a
		ld	h,a

		GET_RND_BY_PARAM	7

		add	a,h
		ld	h,a

		GET_RND_BY_PARAM	7

		add	a,h
		add	a,2
		ld	h,a

		GET_E_FROM_TABLE	$2C

		ld	e,a
		add	a,h

		cp	c
		ret	c

		ld	a,l
		rlca
		rlca
		rlca
		and	7
		ld	(GAME_VARIABLES + VAR_DAMAGE_TYPE),a
		ld	hl,0

.damage_roll:
		GET_RND_BY_PARAM	3

		inc	a
		add	a,l
		ld	l,a

		jr	nc,.roll_no_carry

		inc	h

.roll_no_carry:
		djnz	.damage_roll

		ld	a,e
		add	a,l
		ld	l,a
		jr	nc,.done

		inc	h

.done:
		and	a

		ret
