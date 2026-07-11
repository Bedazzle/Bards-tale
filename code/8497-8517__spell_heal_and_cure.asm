; --- spell_heal_and_cure --------------------------------------
; @done
; Heal and/or cure one hero. Rolls the spell's healing dice (count
; and die from table $4B/$4A), adds the total to the target hero's
; current HP (VAR_TARGET_ID -> ix), capping at the hero's maximum
; hit points. Then, per the spell's cure mask (table $4B/$69),
; clears status ailments - poison / paralysis / nuts / possession -
; via set_status_ok, and for a resurrection-class spell restores a
; dead hero (condition set to 1).
; In:  iy = game variables base; VAR_TARGET_ID selects the hero
; Out: target hero's HP raised (capped) and ailments cleared
; Note: a rolled value of $0F requests a full heal (skip the cap
;       comparison).
spell_heal_and_cure:
		PUSH_REGS

		RESET_DAMAGE

		GET_IY_A_FROM_TABLE	$4B,$4A

		and	$7F
		push	af
		jr	z,.apply_heal

.roll_loop:
		GET_RND_BY_PARAM	3

		add	a,l
		inc	a
		ld	l,a
		djnz	.roll_loop

.apply_heal:
		ld	b,(iy+VAR_TARGET_ID)

		FIND_HERO_BY_B

		pop	af

		cp	$0F
		jr	z,.cap_at_max

		ld	e,(ix+CHAR_COND_LO)
		ld	d,(ix+CHAR_COND_HI)
		add	hl,de
		push	hl
		ld	e,(ix+CHAR_HITS_LO)
		ld	d,(ix+CHAR_HITS_HI)
		and	a
		sbc	hl,de
		pop	hl
		jr	c,.store_hp

.cap_at_max:
		ld	l,(ix+CHAR_HITS_LO)
		ld	h,(ix+CHAR_HITS_HI)

.store_hp:
		ld	(ix+CHAR_COND_LO),l
		ld	(ix+CHAR_COND_HI),h

		GET_IY_A_FROM_TABLE	$4B,$69

		and	$E0 ; 'а'
		ret	z

		ld	b,a

		GET_ATTR_BY_PARAM_SAVE_HL	CHAR_STATUS		; get hero status

		bit	7,b				; ???
		jr	z,.check_cure

		cp	STATUS_POISONED
		jr	z,set_status_ok

		cp	STATUS_PARALYZED
		jr	z,set_status_ok

		cp	STATUS_NUTS
		jr	z,set_status_ok

.check_cure:
		ld	c,a
		ld	a,b

		cp	$E0 ; 'а'
		ld	a,c
		jr	nz,.check_possess

		cp	3
		jr	z,.cure_condition

.check_possess:
		ld	c,a
		ld	a,b

		cp	$C0 ; 'А'
		ld	a,c
		ret	nz

		cp	6
		ret	nz

.cure_condition:
		xor	a
		ld	(ix+CHAR_COND_LO),1
		ld	(ix+CHAR_COND_HI),a
		ld	(ix+CHAR_FORMER_HEALTH),a

		GET_B_FROM_LIST	$56
; -------------------------------------

set_status_ok:
		ld	(ix+CHAR_STATUS),STATUS_OK
		ret
