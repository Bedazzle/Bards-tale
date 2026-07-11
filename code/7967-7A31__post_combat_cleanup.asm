; --- post_combat_cleanup -------------------------------------
; @done
; Tidies party and enemy state after a combat round. First it decides
; whether the summoned-ally slot must be released (ally gone, its
; condition ran out, or its status is dead/expired) and wipes ally
; memory if so. Then it compacts the party: it scans every member,
; drops any that fail CHECK_HERO_STATUS, shifts the survivors up while
; keeping VAR_CURRENT_ACTOR aimed at the right hero, and rebuilds the
; per-turn actor lists. Finally it compacts the enemy group tables,
; deleting emptied monster groups and closing the gaps.
; In:  iy = game variables base, ix = hero/character record
; Out: carry clear on a normal finish
post_combat_cleanup:
		ld	b,0

		FIND_HERO_BY_B

		jr	z,.compact_party

		GET_GAME_VARIABLE	VAR_ALLY_COUNTER			; ???

		jr	nz,.clean_ally

		GET_ATTR_BY_PARAM	CHAR_COND_HI

		jr	nz,.check_status

		inc	hl

		cp	(hl)
		jr	z,.clean_ally

.check_status:
		ld	a,(ix+CHAR_STATUS)		; Character status
		sub	3
		jr	z,.clean_ally

		dec	a
		jr	nz,.compact_party

.clean_ally:
		CLEAN_ALLY_MEMORY

.compact_party:
		CHECK_ALL_HEROES

		ret	c

		inc	b
		ld	c,b
		ld	b,1

.scan_member:
		FIND_HERO_BY_B

		CHECK_HERO_STATUS

		jr	c,.next_member

		ld	a,b

		cp	(iy+VAR_CURRENT_ACTOR)
		jr	nc,.check_last_slot

		dec	(iy+VAR_CURRENT_ACTOR)

.check_last_slot:
		cp	6
		jr	z,.rebuild_lists

.shift_slot:
		ld	hl,DAMAGE_DICE_MASK+$8
		inc	b
		ld	e,3

.shift_slot_byte:
		ld	a,(hl)
		inc	hl
		call	swap_group_field
		dec	e
		jr	nz,.shift_slot_byte

		ld	a,b
		inc	a

		cp	c
		jr	c,.shift_slot

.rebuild_lists:
		xor	a

		GET_B_FROM_LIST	$45

		GET_B_FROM_LIST	$30

		GET_B_FROM_LIST	$2F

.move_up_loop:
		GET_ATTR_BY_PARAM_SAVE_HL	CHAR_POS_IN_PARTY

		cp	6					; last one
		jr	z,.last_member

		push	ix
		pop	hl
		inc	a

		FIND_HERO_BY_A

		push	ix
		pop	de
		ld	a,$64 ; 'd'
		call	swap_byte_buffer

		jr	.move_up_loop

.last_member:
		GET_ATTR_BY_PARAM_SAVE_HL	CHAR_NEG_FLAG

		call	nz,clean_hero_memory
		push	ix
		call	is_roster_full
		pop	de
		push	ix
		pop	hl
		ld	a,$64 ; 'd'
		call	swap_byte_buffer

		jr	.compact_party
; -------------------------------------

.next_member:
		inc	b
		ld	a,b

		cp	c
		jr	c,.scan_member

.enemy_cleanup:
		CHECK_THREE_HEROES

		jr	c,.done
		ld	(iy+VAR_ENEMY_COUNT),b

.scan_group:
		GET_B_FROM_TABLE	$36

		jr	z,.compact_groups

		dec	b
		jp	p,.scan_group

.done:
		and	a

		ret
; -------------------------------------

.compact_groups:
		CALC_IN_FB7D

		ex	de,hl
		inc	b
		ld	a,b

		cp	4
		jr	nc,.clear_group

		CALC_IN_FB7D

		ld	a,$64 		; 'd'
		call	swap_byte_buffer

		ld	a,$36 		; '6'
		call	swap_group_field

		ld	a,$41 		; 'A'
		call	swap_group_field

		ld	a,$57 		; 'W'
		call	swap_group_field

		jr	.compact_groups
; -------------------------------------

.clear_group:
		dec	b
		xor	a

		GET_B_FROM_LIST	$36

		GET_B_FROM_LIST	$41

		ld	b,$64 ; 'd'

.clear_loop:
		ld	(hl),a
		djnz	.clear_loop

		jr	.enemy_cleanup
