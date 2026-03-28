loc_6A66:
		GET_GAME_VARIABLE	VAR_ACTIVE_HERO			; ???

		jr	nc, dyn_proc_55

		ld	(iy+VAR_53), 1

		RST_10_2A

		ret	c

		ld	a, (EL_CID+1)
		or	a
		jr	z, loc_6A7E

		inc	(iy+VAR_53)

		RST_10_2A

		ret	c

loc_6A7E:
		xor	a

		ret
; -------------------------------------

dyn_proc_55:							; RST_10_2A
		GET_RND_NUMBERS

		PUSH_REGS

		GET_GAME_VARIABLE	VAR_ACTIVE_HERO			; ???

		jr	nc, loc_6A96

		call	loc_6AB2
		ld	l, a
		ld	a, (iy+VAR_53)
		push	hl
		call	loc_6ACC

		jr	loc_6AA1

loc_6A96:
		call	loc_6ACC
		ld	l, a
		ld	a, (iy+VAR_53)
		push	hl
		call	loc_6AB2

loc_6AA1:
		pop	hl

		cp	l
		ret	c

		sub	4
		jr	nc, loc_6AA9

		xor	a

loc_6AA9:
		cp	l
		jr	nc, loc_6AB0

		ld	a, 1
		or	a

		ret

loc_6AB0:
		xor	a

		ret

loc_6AB2:
		and	7Fh

		GET_A_FROM_TABLE	41h

		jr	nz, loc_6ABB
		ld	a, 20h ; ' '

loc_6ABB:
		call	divide_A_by_8
		ld	c, a
		ld	a, (GAME_VARIABLES + VAR_RND_HI)
		and	7
		add	a, c

		ret
