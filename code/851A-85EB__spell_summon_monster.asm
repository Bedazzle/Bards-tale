; --- spell_summon_monster -------------------------------------
; @done
; SUMMON spell effect. Rolls how many creatures to bring in, then either
; builds a monster ENEMY record (weak types via table $63, strong via
; CALC_MONSTER_HP + build_summoned_monster) or, on the ally path, adds a
; fighting ally to the party. Announces the result.
; In:  b = summon parameter (bit6 = roll extra count, low 6 bits = base id)
; Note: several effect-table indices ($36/$41/$42/$51/$56/$63) used as-is;
;       per-table meaning partially inferred.
spell_summon_monster:
		and	a,$40
		jr	z,.fixed_count

		ld	a,b
		and	a,$3F
		ld	e,a

		GET_RND_BY_PARAM	1

		add	a,e
		jr	nz,.have_count

.fixed_count:
		ld	a,b
		and	$3F

.have_count:
		ld	b,a

		GET_GAME_VARIABLE	VAR_ACTIVE_HERO		; ???

		jp	z,print_ellipsis
		jr	c,summon_ally

		CLEAN_ALLY_MEMORY

		GET_B_FROM_TABLE	INX_SUMMON_CREAT

		cp	5
		jr	c,.weak_monster

		push	af

		CALC_MONSTER_HP

		ld	(ENEMY+ENEMY_HITS),a
		ld	(ENEMY+ENEMY_COND),a
		pop	af
		call	build_creature_record

		jr	finish_summon
; -------------------------------------

.weak_monster:
		ld	b,a

		GET_B_FROM_TABLE	$63

		ld	l,a
		inc	b

		GET_B_FROM_TABLE	$63

		ld	h,a

setup_enemy:
		ld	bc,$17
		ld	de,ENEMY
		ldir

		ex	de,hl
		inc	hl
		ld	a,$18

.clear_loop:
		ld	(hl),0
		inc	hl
		inc	a

		cp	$3F ; '?'
		jr	c,.clear_loop

		ex	de,hl
		ld	a,(hl)
		ld	(de),a
		inc	hl
		ld	e,(hl)
		inc	hl
		ld	d,(hl)

		GET_RND_NUMBERS

		and	e
		add	a,d
		jr	nc,.cap_hp

		ld	a,$FF

.cap_hp:
		ld	(ENEMY+ENEMY_COND),a
		ld	(ENEMY+ENEMY_HITS),a
		ld	a,CLASS_PARTY
		ld	(ENEMY+ENEMY_CLASS),a

finish_summon:
		call	get_hero_class
		jr	c,.bumped

		xor	a

		jr	.store_flag
; -------------------------------------

.bumped:
		ld	hl,ENEMY+$38
		inc	(hl)
		ld	a,1

.store_flag:
		ld	(ENEMY+ENEMY_SPECIAL_FLAG),a
		ld	b,6

.spell_loop:
		GET_B_FROM_TABLE	$51

		jr	nz,.next_spell

		GET_B_FROM_TABLE	$56

		cp	1
		jr	nz,.next_spell

		exx
		inc	(hl)
		exx

.next_spell:
		djnz	.spell_loop

summon_done:
		jp	print_ellipsis
; -------------------------------------

summon_ally:
		ld	e,b

		CHECK_THREE_HEROES

		jr	c,summon_done

		inc	b
		ld	a,b

		cp	4
		jr	nc,summon_done

		GET_E_FROM_TABLE	INX_SUMMON_CREAT

		call	build_summoned_monster
		call	get_hero_class
		jr	c,.announce

		GET_E_FROM_TABLE	$42

		exx
		inc	(hl)
		exx

.announce:
		PRINT_MESSAGE	$69			; "and"

		xor	a
		ld	(GAME_VARIABLES + VAR_DISPLAY_COUNT),a

		GET_B_FROM_TABLE	$41

		PRINT_WORD

		PRINT_MESSAGE	$6C			; "appears"

		jp	print_ellipsis
; -------------------------------------

; --- build_summoned_monster -----------------------------------
; @done
; Initialise one summoned ally slot: looks the creature up (list
; $41), registers it (table $36), rolls its hit points via
; CALC_MONSTER_HP and clears its spell-effect field. Called once per
; ally from the summon-ally loop (summon_ally).
; In:  b/e = summon creature index; iy = game variables base
; Note: table indices used as-is; purpose partially inferred.
build_summoned_monster:
		GET_B_FROM_LIST	$41

		GET_B_FROM_TABLE	$36

		exx
		inc	(hl)
		exx

		CALC_IN_FB7D

		CALC_MONSTER_HP

		ld	(hl),a

		CALC_SPELL_FX

		ld	(hl),0
		ret
