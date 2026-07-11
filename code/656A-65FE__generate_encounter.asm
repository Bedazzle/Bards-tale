; --- generate_encounter (generate_encounter) ----------------------------
; @done
; Build a fresh combat encounter. Clears the combat buffers, bumps the
; round counter, seeds base spell damage in combat mode, then for each
; enemy group rolls a monster type ($41 list), a quantity ($36 list) and
; per-monster HP (CALC_MONSTER_HP) into the FB7D group buffer. Honours
; the ambush flag and encounter counter, then clears the unused group
; slots.
; In:  iy = game variables base
; Note: reads/writes many VAR_* combat variables (round number, enemy
;       count, base damage, ...).
generate_encounter:
		ZERO_BUFFERS

		inc	(iy+VAR_ROUND_NUMBER)

		GET_GAME_VARIABLE	VAR_COMBAT_MODE			; ???

		jr	z,.build_groups

		GET_IY_A_FROM_TABLE	$54,$43

		ld	e,a
		ld	hl,GAME_VARIABLES + VAR_BASE_DAMAGE

		GET_GAME_VARIABLE	VAR_SPELL_ID			; ???

		jr	nz,.check_spell5

		ld	(hl),e

.check_spell5:
		cp	5
		jr	nz,.build_groups

		inc	hl
		ld	(hl),e

.build_groups:
		ld	b,$FF

		GET_GAME_VARIABLE	VAR_AMBUSH_FLAG			; ???

		jr	nz,.clear_loop

		GET_GAME_VARIABLE	VAR_ENCOUNTER_CTR			; ???

		ld	c,a
		jr	nz,.group_loop

		GET_RND_BY_PARAM	3

		ld	e,a

		GET_GAME_VARIABLE	VAR_UNDERGROUND

		jr	nz,.set_count

		ld	e,0

.set_count:
		ld	(iy+VAR_ENEMY_COUNT),e

.group_loop:
		inc	b

		CALC_IN_FB7D

		dec	c
		inc	c
		jr	z,.roll_count

		GET_B_FROM_TABLE	$41

		jr      nz,.set_group

.roll_count:
		GET_IY_A_FROM_TABLE	$54,$4F

		ld	e,a

		GET_IY_A_FROM_TABLE	$54,$50

		ld	d,a

		GET_RND_NUMBERS

		and	e
		add	a,d
		jr	nz,.set_group

		inc	a

.set_group:
		GET_B_FROM_LIST	$41

		CHECK_ITEM_MASK	$71,7

		jr	z,.calc_qty

		GET_A_FROM_TABLE	$64

.calc_qty:
		dec	c
		inc	c
		jr	nz,.read_qty

		and	(iy+VAR_RND_LO)
		inc	a

		cp	$64			; 100
		jr	c,.store_qty

		ld	a,$63 ; 'c'

.store_qty:
		GET_B_FROM_LIST	$36

.read_qty:
		GET_B_FROM_TABLE	$36

		ld	e,a

.hp_loop:
		GET_B_FROM_TABLE	$41

		CALC_MONSTER_HP

		ld	(hl),a
		inc	hl
		dec	e
		jr	nz,.hp_loop

		ld	a,b

		cp	(iy+VAR_ENEMY_COUNT)
		jr	c,.group_loop

.clear_loop:
		inc	b
		xor	a

		GET_B_FROM_LIST	$41

		GET_B_FROM_LIST	$36

		ld	a,b

		cp	4
		jr	c,.clear_loop

		ret
