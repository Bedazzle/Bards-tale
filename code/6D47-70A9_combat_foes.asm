combat_party:
		ld	(iy+VAR_AMBUSH_FLAG), 1

; -------------------------------------

combat_foes:
		inc	(iy+VAR_PAUSE)		; pause ON
		call	loc_6D55		; combat with enemies
		dec	(iy+VAR_PAUSE)		; pause OFF

		ret

; -------------------------------------

loc_6D55:
		ld	a, (GAME_VARIABLES + VAR_SPELL_ACTIVE)
		ld	(GAME_VARIABLES + VAR_COMBAT_MODE), a
		call	sub_82D2
		call	loc_656A
		call	loc_662A
		call	loc_669A

		jr	loc_6D77
; -------------------------------------

you_still_face:
		PRINT_MESSAGE	0Dh			; "You still face:"

		call	loc_6644
		call	loc_669A

		GET_GAME_VARIABLE	VAR_INITIATIVE_FLAG		; ???

		jr	nz, loc_6D80

loc_6D77:
		call	fight_or_run

		GET_GAME_VARIABLE	VAR_FLEE_SUCCESS		; ???

		jp	nz, loc_6F93

loc_6D80:
		PRINT_NEWLINE

		call	loc_6746
		ld	(iy+VAR_ENEMY_SLOT), 0FFh

loc_6D89:
		ld	b, 0

loc_6D8B:
		GET_B_FROM_TABLE	38h

		cp	(iy+VAR_ENEMY_SLOT)
		jp	nz, loc_6E0C

		exx
		ld	(hl), 0
		exx

		FIND_HERO_BY_B

		jr	z, loc_6E0C

		CHECK_HERO_STATUS

		jr	nc, loc_6E0C

		ld	a, b
		or	a
		jr	nz, loc_6DD5

		GET_ATTR_BY_PARAM_SAVE_HL	CHAR_SPECIAL_FLAG		; ???

		jr	z, loc_6DAE

		GET_GAME_VARIABLE	VAR_ALLY_COUNTER			; ???

		jr	nz, loc_6E0C

loc_6DAE:
		GET_RND_BY_PARAM	3

		add	a, 11h

		GET_A_FROM_TABLE	37h

		jr	z, loc_6DCF

		cp	0FFh
		jr	z, loc_6E0C

		cp	4Fh 	; 'O'
		jr	nc, loc_6DC3

		GET_A_FROM_TABLE	35h

loc_6DC3:
		ld	(GAME_VARIABLES + VAR_CURRENT_SPELL), a
		xor	a
		ld	(GAME_VARIABLES + VAR_ACTIVE_HERO), a
		call	loc_708A
		jr	loc_6DF8
; -------------------------------------

loc_6DCF:
		call	loc_708A
		jp	loc_6E6B
; -------------------------------------

loc_6DD5:
		GET_B_FROM_TABLE	56h

		cp	8
		jr	z, loc_6E39

		cp	4
		jr	z, loc_6E14

		cp	6
		jr	z, loc_6E2D

		cp	1
		jr	z, loc_6E57

		cp	3
		jr	nz, loc_6E0C

		GET_B_FROM_TABLE	3Ch

		ld	(GAME_VARIABLES + VAR_CURRENT_SPELL), a

		GET_B_FROM_TABLE	51h

		call	sub_7099

loc_6DF8:
		PRINT_NEWLINE

		PRINT_IX_HERO_NAME

		ld	a, (GAME_VARIABLES + VAR_CURRENT_SPELL)

		cp	4Fh ; 'O'
		jr	c, loc_6E0F

		cp	5Ah ; 'Z'
		jr	nc, loc_6E0F

loc_6E07:
		call	loc_8325
		jr	loc_6E36
; -------------------------------------

loc_6E0C:
		jp	loc_6EFA
; -------------------------------------

loc_6E0F:
		call	sub_812A
		jr	loc_6E36
; -------------------------------------

loc_6E14:
		GET_B_FROM_TABLE	51h

		ld	(GAME_VARIABLES + VAR_CURRENT_SPELL), a

		GET_B_FROM_TABLE	3Bh

		call	sub_7099

		GET_B_FROM_TABLE	3Ah

		call	loc_75A5
		call	spell_casting
		jr	c, loc_6E07
		jr	loc_6E36
; -------------------------------------

loc_6E2D:
		call	loc_7FF2
		jr	nc, loc_6E36

		PRINT_NEWLINE

		CHANGE_COMBAT_SPEED

loc_6E36:
		jp	loc_6D89
; -------------------------------------

loc_6E39:
		GET_ATTR_BY_PARAM_SAVE_HL	CHAR_STATUS		; get hero status

		cp	STATUS_NUTS
		jr	nz, loc_6E45

		GET_RND_BY_PARAM	1

		jr	loc_6E48
; -------------------------------------

loc_6E45:
		ld	a, (ix+CHAR_FORMER_HEALTH)

loc_6E48:
		or	a
		jr	z, loc_6E4F

		PICK_RANDOM_HERO

		jr	loc_6E5A
; -------------------------------------

loc_6E4F:
		IF_FB98_IS_ZERO

		jr	z, loc_6E0C
		ld	a, 80h

		jr	loc_6E5A
; -------------------------------------

loc_6E57:
		GET_B_FROM_TABLE	51h

loc_6E5A:
		ld	(GAME_VARIABLES + VAR_TARGET_ID), a
		or	a
		jr	nz, loc_6E6B
		ld	a, (ENEMY+ENEMY_SPECIAL_FLAG)
		or	a
		jr	nz, loc_6E6B
		ld	a, 1
		ld	(ENEMY+ENEMY_ACTIVE_FLAG), a

loc_6E6B:
		GET_GAME_VARIABLE	VAR_TARGET_ID			; ???

		jp	c, loc_6E86
		push	ix
		push	bc

		FIND_HERO_BY_A

		pop	bc

		GET_ATTR_BY_PARAM_SAVE_HL	CHAR_STATUS		; get hero status

		pop	ix

		cp	STATUS_DEAD
		jr	c, loc_6E8E

		cp	STATUS_POSSESSED
		jr	nc, loc_6E8E
		jr	loc_6E36
; -------------------------------------

loc_6E86:
		and	7Fh
		ld	c, a

		GET_C_FROM_TABLE	36h

		jr	z, loc_6E36

loc_6E8E:
		PRINT_NEWLINE

		PRINT_IX_HERO_NAME

		ld	a, b
		or	a
		jr	nz, test_chop

		ld	a, (ENEMY+ENEMY_ATTACK_SPEC)
		call	loc_7068

		jr	test_is_missed
; -------------------------------------

test_chop:
		ld	e, 1
		call	loc_7A9E
		jr	nc, test_swing

		PRINT_MESSAGE	5Dh			; "chops"

		PRINT_MESSAGE	65h			; "at"

		jr	test_is_missed
; -------------------------------------

test_swing:
		PRINT_MESSAGE	5Eh			; "swings"

		PRINT_MESSAGE	65h			; "at"

test_is_missed:
		PRINT_ACTOR_NAME

		call	loc_7AB8
		jr	nc, loc_6EBF

		PRINT_MESSAGE	37h			; "but misses!"

		jr	loc_6EEA
; -------------------------------------

loc_6EBF:
		GET_ATTR_BY_PARAM_SAVE_HL	CHAR_ATT_ROUND

		jr	z, loc_6ED2
		push	af

		PRINT_IN_LOOP
		db  36h, 4Eh, 0FFh			; "and"
									; "hits"

		pop	af

		PRINT_NEXT_DIGIT

		PRINT_MESSAGE	53h			; "times for"

		jr	loc_6ED7
; -------------------------------------

loc_6ED2:
		PRINT_IN_LOOP
		db  36h, 4Fh, 0FFh			; "and"
									; "hits for"

loc_6ED7:
		SHOW_DAMAGE

		jr	c, loc_6EE5

		GET_GAME_VARIABLE	VAR_DAMAGE_TYPE		; ???

		jr	nz, loc_6EE5

		PRINT_MESSAGE	63h			; ===empty message===

		jr	loc_6EEA
; -------------------------------------

loc_6EE5:
		ATTACK_AND_RESULT

		PRINT_MESSAGE	62h			; "him!"

loc_6EEA:
		PRINT_NEWLINE

		push	de

		PRINT_STATS_TABLE

		pop	de

		CHECK_ALL_HEROES

		jp	c, oh_dear_game_over

		CHANGE_COMBAT_SPEED

		jp	loc_6D89
; -------------------------------------

loc_6EFA:
		inc	b
		ld	a, b
		cp	7
		jp	nz, loc_6D8B
		ld	b, 0

loc_6F03:
		ld	(iy+VAR_ACTIVE_ENEMY), b

		GET_B_FROM_TABLE	36h

		jr	z, loc_6F22

		ld	c, a

		GET_B_FROM_TABLE	57h

		jr	nz, loc_6F22

		CALC_SPELL_FX

		ld	e, 0

loc_6F15:
		ld	a, (hl)
		cp	(iy+VAR_ENEMY_SLOT)
		jp	z, loc_6FB7
		inc	hl
		inc	e
		ld	a, e
		cp	c
		jr	c, loc_6F15

loc_6F22:
		inc	b
		ld	a, b
		cp	4
		jr	c, loc_6F03
		dec	(iy+VAR_ENEMY_SLOT)
		jp	nz, loc_6D89
		ld	b, 3

loc_6F30:
		GET_B_FROM_TABLE	1

		GET_B_FROM_LIST	57h

		xor	a

		GET_B_FROM_LIST	1

		dec	b
		jp	p, loc_6F30

		call	loc_7906
		ld	a, (ENEMY)
		or	a
		jr	z, loc_6F66

		ld	a, (ENEMY+ENEMY_SPECIAL_FLAG)
		or	a
		jr	z, loc_6F66

		GET_GAME_VARIABLE	VAR_ALLY_COUNTER

		jr	nz, loc_6F66
		ld	(iy+VAR_ACTIVE_HERO), 1
		ld	(iy+VAR_TARGET_ID), 80h

		CHECK_FLEE_RESULT

		jr	c, loc_6F66

		inc	(iy+VAR_ALLY_COUNTER)

		PRINT_MESSAGE	0Eh			; "Your foes see through your illusion!"

		CHANGE_COMBAT_SPEED

loc_6F66:
		call	process_poison
		call	loc_7DF9
		call	loc_7967
		push	af

		PRINT_STATS_TABLE

		pop	af
		jp	c, oh_dear_game_over

		CHECK_THREE_HEROES

		jr	nc, loc_6FB4

		FIND_ALIVE_HERO

		jr	c, loc_6FB4

		GET_GAME_VARIABLE	VAR_AMBUSH_FLAG		; ???

		jr	z, loc_6F90

		PRINT_MESSAGE	0Fh			; "Do you wish to continue?"

		PRINT_YES_NO_WAIT

		push	af

		PRINT_NEWLINE

		pop	af
		jr	c, loc_6FB4
		jr	loc_6F93
; -------------------------------------

loc_6F90:
		call	enemies_killed

loc_6F93:
		ZERO_BUFFERS

		CLEAR_INFO_PANEL

		xor	a
		ld	(GAME_VARIABLES + VAR_AMBUSH_FLAG), a
		ld	(GAME_VARIABLES + VAR_ENCOUNTER_CTR), a
		ld	a, (ENEMY+ENEMY_ATTACK_SPEC)
		or	a
		jr	nz, loc_6FA6

		CLEAN_ALLY_MEMORY

loc_6FA6:
		GET_GAME_VARIABLE	VAR_COMBAT_MODE			; ???

		jr	z, loc_6FB1
		ld	a, (GAME_VARIABLES + VAR_SPELL_ID)
		call	loc_82D7

loc_6FB1:
		jp	dyn_proc_07
; -------------------------------------

loc_6FB4:
		jp	you_still_face
; -------------------------------------

loc_6FB7:
		push	bc
		ld	(hl), 0

		GET_RND_BY_PARAM	3

		ld	c, a
		ld	d, 4
		call	loc_6813
		ld	(GAME_VARIABLES + VAR_TARGET_ID), a
		push	bc
		push	ix

		FIND_HERO_BY_A

		CHECK_HERO_STATUS

		pop	ix
		pop	bc
		jr	nc, loc_7006

loc_6FD2:
		ld	h, 0

		GET_B_FROM_TABLE	41h

		ld	l, a
		add	hl, hl
		add	hl, hl
		push	bc
		ld	b, 0
		add	hl, bc
		ld	b, h
		ld	c, l
		call	sub_713D
		pop	bc
		jr	z, loc_701C

		cp	4Fh
		jr	nc, loc_6FED

		GET_A_FROM_TABLE	35h

loc_6FED:
		ld	(GAME_VARIABLES + VAR_CURRENT_SPELL), a
		push	af
		ld	a, b
		or	80h
		ld	(GAME_VARIABLES + VAR_ACTIVE_HERO), a

		PRINT_NEWLINE

		call	loc_70A0
		pop	af

		cp	4Fh
		jr	nc, loc_7008

		call	sub_812A

		PRINT_NEWLINE

loc_7006:
		jr	loc_7064
; -------------------------------------

loc_7008:
		cp	0FEh
		jr	z, loc_7013

		call	loc_8325

		PRINT_NEWLINE

		jr	loc_7064
; -------------------------------------

loc_7013:
		call	loc_7FB3
		jr	c, loc_7033

		PRINT_NEWLINE

		jr	loc_7064
; -------------------------------------

loc_701C:
		ld	a, b

		cp	2
		jr	c, loc_702B

		inc	c
		ld	a, c
		and	3
		ld	c, a
		dec	d
		jr	nz, loc_6FD2
		jr	loc_7064
; -------------------------------------

loc_702B:
		PRINT_NEWLINE

		PRINT_MESSAGE	10h			; "A"

		call	loc_70A0

loc_7033:
		GET_B_FROM_TABLE	41h

		call	loc_7068
		ld	a, (GAME_VARIABLES + VAR_TARGET_ID)

		PRINT_ACTOR_NAME

		call	loc_7BF4
		jr	nc, loc_7048

		PRINT_MESSAGE	37h			; "but misses!"

		jr	loc_705B

loc_7048:
		PRINT_IN_LOOP
		db  36h, 4Fh, 0FFh			; "and"
									; "hits for"

		SHOW_DAMAGE

		jr	nc, loc_7058

		ATTACK_AND_RESULT

		PRINT_MESSAGE	62h			; "him!"

		jr	loc_705B

loc_7058:
		PRINT_MESSAGE	63h			; ===empty message===

loc_705B:
		PRINT_STATS_TABLE

		CHECK_ALL_HEROES

		jp	c, oh_dear_game_over

		CHANGE_COMBAT_SPEED

loc_7064:
		pop	bc
		jp	loc_6F03

loc_7068:
		push	af

		PRINT_SPACE

		GET_RND_BY_PARAM	1

		ld	c, a
		pop	af

		GET_A_FROM_TABLE	74h

		add	a, a
		add	a, c
		push	af
		add	a, 94h 		; '”'

		PRINT_WORD

		pop	af

		cp	7
		ret	z

		cp	0Ah
		ret	z

		cp	0Dh
		ret	z

		PRINT_SPACE

		PRINT_MESSAGE	65h			; "at"

		ret
; -------------------------------------

loc_708A:
		ld	(iy+VAR_TARGET_ID), 80h
		ld	a, (ENEMY+ENEMY_ACTIVE_FLAG)
		or	a
		ret	z

		PICK_RANDOM_HERO

		ld	(GAME_VARIABLES + VAR_TARGET_ID), a

		ret

; -------------------------------------

sub_7099:
		ld	(GAME_VARIABLES + VAR_TARGET_ID), a
		ld	(iy+VAR_ACTIVE_HERO), b

		ret

; -------------------------------------

loc_70A0:
		xor	a
		ld	(GAME_VARIABLES + VAR_DISPLAY_COUNT), a

		GET_B_FROM_TABLE	41h

		jp	print_word
