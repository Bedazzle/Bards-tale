; --- roll_from_daypart_table ($D9FF-$DA1E) ---------------------
; @wip
; Sum a table by daypart (iy+$54) then roll a random amount from it.

roll_from_daypart_table:
		ld	e,(iy+$36)
		ld	d,0
		add	hl,de
		ld	b,(iy+$54)
		inc	b
		xor	a
		ld	e,a
		ld	d,a
.da0c:
		add	a,(hl)
		djnz	.da0c
		ex	de,hl
		or	a
		ret	z
		ld	b,a
.da13:
		GET_RND_NUMBERS
		and	3
		add	a,l
		ld	l,a
		jr	nc,.da1c
		inc	h
.da1c:
		djnz	.da13
		ret
