; --- summon_creature -----------------------------------------------
; @done
; Spell effect that summons an ally creature into the enemy/actor
; list. Checks the summon takes (CHECK_FLEE_RESULT), validates the
; target monster type against tables $42/$36, builds the creature's
; combat record (via build_creature_record), rolls its hit points and installs
; it; prints "but it had no effect!" and bails on any failure.
; In:  iy = game variables base, VAR_TARGET_ID = summoned type
; Note: purpose partially inferred.
summon_creature:
		CHECK_FLEE_RESULT

		jr	c,.do_summon

.no_effect:
		PRINT_MESSAGE	$6A			; "but it had no effect!"

		jp	change_combat_speed

.do_summon:
		CLEAN_ALLY_MEMORY

		ld	a,(GAME_VARIABLES + VAR_TARGET_ID)
		and	$7F
		ld	c,a

		GET_C_FROM_TABLE	$42

		jr	nz,.no_effect

		GET_C_FROM_TABLE	$36

		jr	z,.no_effect
		dec	a
		exx
		ld	(hl),a
		exx

		GET_C_FROM_TABLE	$41

		call	build_creature_record
		ld	b,c

		CALC_IN_FB7D

		ld	b,$64 ; 'd'

.find_hp_loop:
		ld	a,(hl)
		inc	hl
		or	a
		jr	nz,.store_hp

		djnz	.find_hp_loop

		inc	a

.store_hp:
		ld	(ENEMY+ENEMY_COND),a
		ld	(ENEMY+ENEMY_HITS),a

		jp	print_ellipsis
; -------------------------------------

; --- build_creature_record -----------------------------------------------
; @done
; Builds the summoned creature's actor/combat record: locates the
; actor slot, copies four combat-data bytes (via show_monster_magic), writes
; the monster special / HP-AC fields from the monster tables and
; initialises the remaining record fields, tagging it as class $0A.
; In:  a = actor index, d = monster type
; Out: ENEMY record populated, (ix+CHAR_CLASS)=$0A
; Note: field-init loop partially inferred.
build_creature_record:
		ld	l,a
		ld	d,a
		ld	b,0
		ld	h,b

		FIND_HERO_BY_B

		xor	a
		ld	(GAME_VARIABLES + VAR_DISPLAY_COUNT),a
		ld	a,l

		PRINT_EMPTY

		add	hl,hl
		add	hl,hl
		ld	b,h
		ld	c,l
		ld	hl,ENEMY + ENEMY_COMBAT_DATA
		ld	e,4

.copy_combat_loop:
		call	show_monster_magic
		ld	(hl),a
		inc	bc
		inc	hl
		dec	e
		jr	nz,.copy_combat_loop

		GET_D_FROM_TABLE	INX_MONST_SPEC

		ld	(hl),a
		inc	hl
		ld	(hl),d
		inc	hl
		ld	a,$17

.clear_field:
		ld	(hl),0

.next_field:
		inc	hl
		inc	a

		cp	'1'
		jr	z,.next_field

		cp	'3'
		jr	z,.next_field

		cp	'?'
		jr	c,.clear_field

		GET_D_FROM_TABLE	INX_MONST_HP_AC

		and	$1F
		ld	(hl),a
		ld	(ix+CHAR_CLASS),$0A

		ret
