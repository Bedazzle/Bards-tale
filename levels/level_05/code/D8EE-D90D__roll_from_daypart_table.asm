; --- roll_from_daypart_table ($D8EE-$D90D) ----------------------------------
; @done
; Sum a table by daypart (iy+$54) then roll a random amount from it.
; In:  hl = table base
; Out: a = amount summed by daypart then randomised

roll_from_daypart_table:
		ld	e,(iy+$36)
		ld	d,0
		add	hl,de
		ld	b,(iy+$54)
		inc	b
		xor	a
		ld	e,a
		ld	d,a
.loop:
		add	a,(hl)
		djnz	.loop
		ex	de,hl
		or	a
		ret	z
		ld	b,a
.loop2:
		GET_RND_NUMBERS
		and	3
		add	a,l
		ld	l,a
		jr	nc,.done
		inc	h
.done:
		djnz	.loop2
		ret
