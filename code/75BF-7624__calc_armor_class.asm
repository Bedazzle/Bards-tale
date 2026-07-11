; --- calc_armor_class -----------------------------------------------
; @done
; Recomputes one hero's armor class and repaints the stats table.
; Thin wrapper: clears the running modifier (e=0), calls calc_ac_worker to
; do the work, then jumps to print_stats_table.
; In:  ix = hero record
calc_armor_class:
		ld	e,0
		call	calc_ac_worker

		jp	print_stats_table

; --- calc_ac_worker -----------------------------------------------
; @done
; Computes and stores a hero's natural armor class
; (CHAR_NATURAL_AC). Starts from a dexterity bonus (Dx-15), adds a
; Monk level bonus, sums the AC contribution of every equipped
; inventory item, adds the base-armour bytes and subtracts the
; global stat modifier, then clamps the result to a maximum of $15
; (21). Party-class actors (CLASS_PARTY and above) take a simplified
; path using the defence-special byte.
; In:  ix = hero record, e = starting AC modifier, iy = game vars
; Out: (ix+CHAR_NATURAL_AC) updated
; Note: AC is capped at $15.
calc_ac_worker:
		PUSH_REGS

		ld	a,(ix+CHAR_PARAMS_LO)
		and	$1F
		sub	$0F
		jr	c,.check_class

		add	a,e
		ld	e,a

.check_class:
		ld	a,(ix+CHAR_CLASS)			; Char Class

		cp	CLASS_PARTY
		jr	nc,.monster_ac

		cp	CLASS_MONK
		jr	nz,.scan_inventory

		GET_ATTR_BY_PARAM	CHAR_MAXLEVEL_HI

		jr	nz,.max_ac

		inc	hl
		ld	a,(hl)
		add	a,e
		jr	c,.max_ac

		cp	$15
		jr	nc,.max_ac

		ld	e,a

.scan_inventory:
		FIND_ATTR_AND_ADDRESS	CHAR_INVENTORY

		ld	b,8

.item_loop:
		ld	a,(hl)

		cp	1
		inc	hl
		jr	nz,.next_item

		ld	a,(hl)

		CHECK_ITEM_MASK	$73,$0F

		add	a,e
		ld	e,a

.next_item:
		inc	hl
		djnz	.item_loop

.apply_modifier:
		GET_ATTR_SAVE_IX	$55

		inc	hl
		add	a,(hl)
		inc	hl
		add	a,(hl)
		add	a,e
		sub	(iy+VAR_STAT_MODIFIER)
		jr	nc,.clamp_high

		xor	a

.clamp_high:
		cp	$15
		jr	c,.store_ac

.max_ac:
		ld	a,$15

.store_ac:
		ld	(ix+CHAR_NATURAL_AC),a

		ret
; -------------------------------------

.monster_ac:
		ld	a,(ix+CHAR_DEFENSE_SPEC)

		CHECK_ITEM_MASK	$44,$1F

		ld	e,a

		jr	.apply_modifier
