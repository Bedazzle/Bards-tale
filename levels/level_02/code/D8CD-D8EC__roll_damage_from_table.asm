; --- roll_damage_from_table --------------------------------
; @done
; Sum (iy+$54)+1 bytes of a spec table (base hl + iy+$36) to get a dice count N,
; then roll N d4 (random & 3) accumulating into hl.
; In: hl = table base.  Out: hl = rolled total.
roll_damage_from_table:
		ld	e,(iy+$36)
		ld	d,0
		add	hl,de
		ld	b,(iy+$54)
		inc	b
		xor	a
		ld	e,a
		ld	d,a
.sum:
		add	a,(hl)
		djnz	.sum
		ex	de,hl
		or	a
		ret	z
		ld	b,a
.roll:
		GET_RND_NUMBERS
		and	3
		add	a,l
		ld	l,a
		jr	nc,.no_carry
		inc	h
.no_carry:
		djnz	.roll
		ret
