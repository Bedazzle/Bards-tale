; --- calc_xp_for_level -----------------------------------------------
; @done
; Computes the experience-point threshold a hero needs to reach a
; given level and compares it against his current XP. Indexes table
; $49 by class*13 + level: for levels below 13 it takes the value
; directly, otherwise it accumulates 21 per level above the base;
; the result is compared to CHAR_EXP via check_12_digits.
; In:  ix = hero record, hl = target level
; Out: carry reflects the XP comparison (nc = threshold reached)
; Note: purpose partially inferred from the BCD/table arithmetic.
calc_xp_for_level:
		ld	b,(ix+CHAR_CLASS)
		inc	b
		ld	a,$F3

.class_offset:
		add	a,$0D
		djnz	.class_offset

		ld	de,$0D
		and	a
		sbc	hl,de
		jr	c,.low_level

		add	a,$0C

		GET_A_FROM_TABLE	$49

		call	store_bcd_and_compare
		inc	hl

.exp_loop:
		ld	a,$15
		call	add_to_bcd_number
		dec	hl
		ld	a,l
		or	h
		jr	nz,.exp_loop

		ld	e,CHAR_EXP_START

		jp	check_12_digits

.low_level:
		add	hl,de
		add	a,l

		GET_A_FROM_TABLE	$49

		ld	e,$14

		jp	store_bcd_and_compare
