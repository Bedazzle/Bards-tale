; --- store_bcd_and_compare -----------------------------------------------
; @done
; Converts an 8-bit value into BCD digits and stores them in the
; cleared amount buffer (positioned via bcd_index_to_addr), then falls into
; check_12_digits to compare that amount against a hero field.
; In:  a = value, e = field selector
; Note: digit-placement math partially inferred.
store_bcd_and_compare:
		PUSH_REGS

		push	af

		NULLIFY_FB5B

		pop	af
		call	bcd_index_to_addr
		dec	hl

.tens_loop:
		cp	$0A
		jr	c,.store_units

		inc	(hl)
		sub	$0A

		jr	.tens_loop

.store_units:
		inc	hl
		ld	(hl),a

; --- check_12_digits ----------------------------------------
; @done
; Compares the 12-digit amount in SOME_BUFF against a hero attribute
; field (selected by e), most-significant digit first.
; In:  e = field offset, SOME_BUFF = amount
; Out: carry set if the hero's value is less than the amount
;      (can't afford); z if all 12 digits are equal.
; Note: used to test affordability of a cost (gold / spell / xp).
check_12_digits:
		PUSH_REGS

		ld	a,e

		GET_ATTR_BY_A

		ex	de,hl
		ld	hl,SOME_BUFF
		ld	b,$0C

.cmp_loop:
		ld	a,(de)

		cp	(hl)
		ret	nz

		inc	hl
		inc	de
		djnz	.cmp_loop

		ret
