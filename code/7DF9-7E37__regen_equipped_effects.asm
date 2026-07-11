; --- regen_equipped_effects ---------------------------------
; @done
; Per-turn upkeep for equipment/spell regeneration. For every party
; slot: if a hit-point regeneration item (type 2) is equipped,
; regenerate the hero's hit points; and if a spell-point
; regeneration item (type 1) is equipped, or a regeneration spell
; (id 3) is active on the current actor, regenerate spell points.
; In:  iy = game variables
regen_equipped_effects:
		inc	(iy+VAR_PAUSE)		; pause ON
		ld	c,6

.hero_loop:
		ld	b,c

		FIND_HERO_BY_B

		CHECK_EQUIPPED	2

		jr	c,.check_spell
		jr	nz,.check_spell

		ld	e,$34 ; '4'
		ld	b,1
		call	regen_stat_paused

		jr	.next_hero

.check_spell:
		GET_GAME_VARIABLE	VAR_SPELL_ACTIVE			; ???

		jr	z,.check_sp_item
		ld	a,c

		cp	(iy+VAR_CURRENT_ACTOR)
		jr	nz,.check_sp_item

		ld	a,(GAME_VARIABLES + VAR_SPELL_ID)

		cp	3
		jr	z,.regen_sp

.check_sp_item:
		CHECK_EQUIPPED	1

		jr	c,.next_hero
		jr	nz,.next_hero

.regen_sp:
		ld	e,$30 ; '0'
		ld	b,1
		call	regen_stat_paused

.next_hero:
		dec	c
		jr	nz,.hero_loop

		dec	(iy+VAR_PAUSE)		; pause OFF

		ret
