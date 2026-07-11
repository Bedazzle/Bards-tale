; --- apply_damage_to_hero -----------------------------------
; @done
; Apply a resolved damage/effect packet to a single hero. Subtracts
; the damage from the hero's current hit points (CHAR_COND); if that
; reaches zero or below the hero dies (status 3). Otherwise the
; effect selected by VAR_DAMAGE_TYPE is applied - level drain, stat
; swap, timed ailment and similar - which may set a status of its
; own. Empty, stoned or already-dead heroes are skipped (a dead hero
; is only affected by damage type 5). If the whole party is down it
; branches to oh_dear_game_over.
; In:  a = hero id, de = damage amount, iy = game variables,
;      VAR_DAMAGE_TYPE = effect selector (0 = plain hit)
; Out: cf set when the hero was processed
; Note: a status change on the currently-acting hero calls
;       process_special_event; effect-type meanings partially
;       inferred.
apply_damage_to_hero:
		FIND_HERO_BY_A

		jr	z,group_damage_done

		ld	a,(ix+CHAR_STATUS)

		cp	STATUS_STONED
		jr	z,group_damage_done

		cp	STATUS_DEAD
		jr	nz,.subtract_hp

		ld	a,(GAME_VARIABLES + VAR_DAMAGE_TYPE)	; ???

		cp	5
		jr	z,.status_by_type

		jr	group_damage_done

.subtract_hp:
		ex	de,hl

		GET_ATTR_BY_PARAM	CHAR_COND_LO

		sub	e
		ld	(hl),a
		dec	hl
		ld	a,(hl)
		sbc	a,d
		ld	(hl),a
		ld	a,0
		jr	c,.mark_killed
		jr	nz,.status_by_type

		inc	hl

		cp	(hl)
		jr	z,.mark_killed

.status_by_type:
		GET_GAME_VARIABLE	VAR_DAMAGE_TYPE			; ???

		jr	z,.no_status

		dec	a
		jr	z,.type1

		dec	a
		jr	z,.drain_level

		dec	a
		jr	z,.type3

		dec	a
		jr	z,.type4_swap

		dec	a
		jp	z,.type5

		dec	a
		jr	z,.type6

		jr	.kill_hero
; -------------------------------------

.type6:
		ld	(ix+CHAR_COND_HI),a
		ld	(ix+CHAR_COND_LO),a
		ld	a,4

		jr	.set_status
; -------------------------------------

.no_status:
		ld	(GAME_VARIABLES + VAR_DAMAGE_TYPE),a
		and	a

		ret
; -------------------------------------

.mark_killed:
		ld	(GAME_VARIABLES + VAR_DAMAGE_TYPE),a

.kill_hero:
		xor	a
		ld	(ix+CHAR_COND_HI),a
		ld	(ix+CHAR_COND_LO),a
		ld	(ix+CHAR_FORMER_HEALTH),a
		ld	a,3

.set_status:
		ld	(ix+CHAR_STATUS),a
		ld	a,(GAME_VARIABLES + VAR_TARGET_ID)
		cp	(iy+VAR_CURRENT_ACTOR)
		call	z,process_special_event

		CHECK_ALL_HEROES

		jp	c,oh_dear_game_over

.done:
		scf

		ret
; -------------------------------------

.drain_level:
		add	a,b
		jr	z,.no_status

		GET_ATTR_BY_PARAM	CHAR_LEVEL_HI

		inc	hl
		ld	a,(hl)
		jr	nz,.do_drain

		dec	a
		jr	z,.no_status

		inc	a

.do_drain:
		ex	de,hl
		sub	1
		ld	(de),a
		ld	l,a
		dec	de
		ld	a,(de)
		sbc	a,0
		ld	(de),a
		ld	h,a
		call	calc_xp_for_level
		call	copy_hero_gold
		scf

		ret
; -------------------------------------

.type3:
		ld	c,7

		jr	.apply_ailment
; -------------------------------------

.type1:
		ld	c,1

.apply_ailment:
		GET_ATTR_BY_PARAM_SAVE_HL	CHAR_STATUS		; get hero status

		jr	nz,.done

		ld	a,c

.goto_set_status:
		jr	.set_status
; -------------------------------------

.type4_swap:
		GET_GAME_VARIABLE	VAR_TARGET_ID		; ???

		jr	z,.no_status
		ld	a,(ix+CHAR_STATUS)

		cp	2
		jr	z,.done

		FIND_ATTR_AND_ADDRESS	CHAR_SAVED_STATS

		ex	de,hl

		FIND_ATTR_AND_ADDRESS	CHAR_SWAP_STATS

		ld	b,3

.swap_loop:
		ld	a,(de)
		ld	(hl),a

		GET_B_FROM_TABLE	$4E		; ??? CHAR_FORMER_HEALTH ???

		ld	(de),a
		dec	hl
		dec	de
		dec	b
		jp	p,.swap_loop

		ld	c,2

		jr	.apply_ailment
; -------------------------------------

.type5:
		ld	(ix+CHAR_COND_HI),a
		ld	a,$64
		ld	(ix+CHAR_COND_LO),a

		GET_GAME_VARIABLE	VAR_ACTIVE_HERO		; ???

		jr	nc,.status6

		ld	a,1
		ld	(ix+CHAR_FORMER_HEALTH),a

.status6:
		ld	a,6
		jr	.goto_set_status
