; --- proc_temple --------------------------------------------
; @done
; The Temple location handler. Repeatedly asks which hero needs
; healing, assesses that hero (bad shape / wounded / life-force
; drained / nothing needed), quotes a price, then lets any party
; member pay. On payment it cures the status ailment or restores the
; drained level(s) and refills HP, then returns to the welcome loop.
; (E)xit leaves via process_exit.
; In:  iy = game variables base
; Note: healing cost is derived from the hero's status/level via cost
;       table $12, or 10 gold per missing hit point for plain wounds.
proc_temple:
		SHOW_NAME_AND_PICTURE	0,PIC_TEMPLE		; Temple

temple_welcome:
		CLEAR_INFO_PANEL

		PRINT2_IN_LOOP
		DB 1,9,8,$5C,$FF		; "Welcome"
										; "oh weary ones, to our humble temple. Who needeth healing?"
										; "(E)xit"
										; "temple"

loop_temple_hero:
		call	enter_hero_num
		jr	nc,enter_temple

		cp	'E'
		jr	nz,loop_temple_hero

		jp	process_exit
; -------------------------------------

enter_temple:
		CLEAR_INFO_PANEL

		PRINT_IX_HERO_NAME

		GET_ATTR_BY_PARAM	CHAR_STATUS

		jr	nz,.bad_shape

		call	compare_char_attrs
		jr	nz,.assess_health

		ld	a,2
		ld	(hl),a

.bad_shape:
		PRINT_MESSAGE2	$5F		; "is in bad shape, indeed."

		jr	.cost_from_table
; -------------------------------------

.assess_health:
		xor	a
		ld	(GAME_VARIABLES + VAR_TEMPLE_TIMER),a

		GET_ATTR_BY_PARAM	CHAR_HITS_LO

		inc	hl
		inc	hl
		sub	(hl)
		ld	e,a
		dec	hl
		dec	hl
		dec	hl
		ld	a,(hl)
		inc	hl
		inc	hl
		sbc	a,(hl)
		ld	d,a
		or	e
		jr	nz,.wounded

		GET_ATTR_BY_PARAM	CHAR_MAXLEVEL_HI

		inc	hl
		inc	hl

		cp	(hl)
		jr	z,.check_level_lo
		jr	nc,.drained
		jr	.no_healing_needed
; -------------------------------------

.check_level_lo:
		dec	hl
		ld	a,(hl)
		inc	hl
		inc	hl

		cp	(hl)
		jr	z,.no_healing_needed
		jr	c,.no_healing_needed

.drained:
		inc	(iy+VAR_TEMPLE_TIMER)

		PRINT_MESSAGE2	$62		; "has been drained of life force."

		ld	a,8
		jr	.cost_from_table
; -------------------------------------

.no_healing_needed:
		PRINT_MESSAGE2	$5E		; "does not require any healing."

		CHANGE_SPEED_TO_8

		jr	temple_welcome
; -------------------------------------

.wounded:
		PRINT_MESSAGE2	$61		; "has wounds which need tending."

		ex	de,hl
		ld	b,0
		ld	d,b
		ld	e,b

.cost_loop:
		ld	c,1
		and	a
		sbc	hl,bc
		jr	c,.charge
		ld	c,$0A
		ex	de,hl
		add	hl,bc
		ex	de,hl

		jr	.cost_loop
; -------------------------------------

.cost_from_table:
		add	a,a
		ld	h,a

		GET_H_FROM_TABLE	$12

		ld	e,a
		inc	h

		GET_H_FROM_TABLE	$12

		ld	d,a
		ld	hl,0
		ld	b,$0D

		GET_ATTR_BY_PARAM	CHAR_LEVEL_HI

		jr	nz,.mul_by_level

		inc	hl
		ld	a,(hl)

		cp	$0E
		jr	nc,.mul_by_level

		ld	b,a

.mul_by_level:
		add	hl,de
		djnz	.mul_by_level

		ex	de,hl

.charge:
		PRINT_MESSAGE2	$5D			; "It will cost"

		PRINT_NUM_FROM_DE

		PRINT2_IN_LOOP
		DB $6F,$17,$FF			; "in gold."
									; "Who will pay?"

		PRINT_MESSAGE	$44			; "(1-6)"

		GET_ATTR_BY_PARAM_SAVE_HL	$64			; get hero position in party

		ld	b,a
		call	enter_hero_num
		jp	c,temple_welcome

		ld	e,CHAR_GOLD_START
		push	bc
		call	check_12_digits
		pop	bc
		jr	nc,.pay

		FIND_HERO_BY_B

		PRINT_2_NEWLINES

		PRINT_MESSAGE	$1B			; "Not enough"

		PRINT_MESSAGE	$7B			; "gold"

		CHANGE_SPEED_TO_8

		jp	enter_temple
; -------------------------------------

.pay:
		ld	e,CHAR_GOLD_START
		call	decreas_12_digits

		FIND_HERO_BY_B

		GET_ATTR_BY_PARAM	CHAR_STATUS

		jr	z,.restore_level

		push	af
		xor	a
		ld	(hl),a
		ld	(ix+CHAR_FORMER_HEALTH),a
		pop	af

		cp	2
		jr	z,.status2_fixup

		cp	6
		jr	nz,.fix_condition

		ld	a,$32

		GET_ATTR_BY_A

		xor	a
		ld	(hl),a

         inc     hl
         jr      .set_condition

.status2_fixup:
		call	copy_char_params

.fix_condition:
		GET_ATTR_BY_PARAM	CHAR_COND_HI

		jr	nz,.healed

		inc	hl
		ld	a,(hl)
		or	a
		jr	nz,.healed

.set_condition:
		ld	(hl),1

		jr	.healed
; -------------------------------------

.restore_level:
		GET_ATTR_SAVE_IX	$37

		jr	z,.restore_hp

		dec	(hl)

		GET_ATTR_BY_PARAM	CHAR_MAXLEVEL_HI

		ld	d,a
		ld	(ix+CHAR_LEVEL_HI),a
		inc	hl
		ld	a,(hl)
		ld	e,a
		ld	(ix+CHAR_LEVEL_LO),a
		dec	de
		ex	de,hl
		call	calc_xp_for_level
		ld	b,$0C

		GET_ATTR_BY_PARAM	CHAR_EXP_END

		ld	de,LEVEL_STOP+$A

.copy_xp:
		ld	a,(de)
		ld	(hl),a
		dec	hl
		dec	de
		djnz	.copy_xp

		jr	.healed
; -------------------------------------

.restore_hp:
		GET_ATTR_BY_PARAM	CHAR_HITS_HI

		ld	(ix+CHAR_COND_HI),a
		inc	hl
		ld	a,(hl)
		ld	(ix+CHAR_COND_LO),a

.healed:
		PRINT_MESSAGE2	$0A			; "The preists lay hands on him..."

		CHANGE_SPEED_TO_8

		PRINT_MESSAGE2	$60			; "...and he is healed!"

		RECALC_ALL_AC

		CHANGE_SPEED_TO_8

		jp	temple_welcome
