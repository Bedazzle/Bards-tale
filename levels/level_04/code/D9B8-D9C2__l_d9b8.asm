; --- l_d9b8 ($D9B8-$D9C2) ----------------------------------
; @wip

l_d9b8:
		ld	b,6
		ld	c,a
.loop:
		ld	a,c
		call	var_6CDA
		ret	nc
		djnz	.loop
		ret
