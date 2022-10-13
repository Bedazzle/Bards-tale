unpack_hero_attrs:
		PUSH_REGS

		ld	b, 2
		ld	de, addr_FB5C

loop_unpack_attrs:
		ld	h, (ix+CHAR_PARAMS_HI)
		ld	l, (ix+CHAR_PARAMS_LO)
		ld	a, h
		call	divide_A_by_8
		ld	(de), a		; put St on first loop, then Cn on second
		inc	de
		push	hl
		add	hl, hl
		add	hl, hl
		ld	a, h
		and	1Fh
		ld	(de), a		; put IQ, then Lk
		inc	de
		pop	hl
		ld	a, l
		and	1Fh
		ld	(de), a		; put Dx, then ???
		inc	de
		inc	ix
		inc	ix
		djnz	loop_unpack_attrs

		ret

		; 10h        11h          10h        11h
		; 0000-0|000 00|0|0-0000| 0000-0|000 00|0|0-0000
		; ST     IQ     ? DX      CN     LK     ? ?
