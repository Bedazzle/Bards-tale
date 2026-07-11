; --- award_experience -----------------------------------------
; @done
; Splits a combat experience award across the whole party and adds
; each living hero's share to their 12-digit (BCD) experience total.
; The pooled amount is divided by the number of heroes (repeated
; subtraction) to give a per-head share, converted to decimal, then
; added to every hero. When the award type is $14 each hero's
; won-combats counter is also bumped.
; In:  a = award type/amount, iy = game variables
; Note: division/remainder handling (VAR_TREASURE_LO) partially
;       inferred.
award_experience:
		push	af

		CHECK_ALL_HEROES

		ld	c,b
		ld	de,0
		ld	b,d

.div_loop:
		and	a
		sbc	hl,bc
		jr	nc,.add_share

		dec	(iy+VAR_TREASURE_LO)
		jp	m,.ensure_min

.add_share:
		inc	de
		ld	a,d

		cp	$FF
		jr	nz,.div_loop

.ensure_min:
		xor	a
		or	d
		or	e
		jr	nz,.to_decimal

		inc	de

.to_decimal:
		call	binary_to_decimal
		pop	af
		ld	e,a
		ld	b,c

.award_loop:
		FIND_HERO_BY_B

		call	increas_12_digits
		ld	a,e

		cp	$14
		jr	nz,.next_hero

		FIND_ATTR_AND_ADDRESS	CHAR_WON_COMBATS_LO

		inc	(hl)
		dec	hl
		jr	nz,.next_hero

		inc	(hl)

.next_hero:
		djnz	.award_loop

		ret
