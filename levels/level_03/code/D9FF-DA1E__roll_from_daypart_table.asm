; --- roll_from_daypart_table ($D9FF-$DA1E) ---------------------
; @done
; Sum a table by daypart (iy+$54) then roll a random amount from it.
; In:  hl = table base
; Out: a = amount summed by daypart then randomised

roll_from_daypart_table:
		ld	e,(iy+$36)		; enemy-group offset into the table
		ld	d,0
		add	hl,de
		ld	b,(iy+$54)
		inc	b			; daypart + 1 = how many rows to sum
		xor	a
		ld	e,a
		ld	d,a
.sum_loop:
		add	a,(hl)
		djnz	.sum_loop
		ex	de,hl
		or	a
		ret	z			; nothing to roll
		ld	b,a			; roll that many d4-ish steps
.roll_loop:
		GET_RND_NUMBERS
		and	3
		add	a,l
		ld	l,a
		jr	nc,.no_carry
		inc	h
.no_carry:
		djnz	.roll_loop
		ret
