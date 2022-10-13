push_regs:
		exx
		pop	de
		exx
		ld	(keeper_hl), hl
		ex	(sp), hl
		push	de
		push	bc
		push	ix
		push	iy
		push	hl
		ld	hl, pop_regs
		ex	(sp), hl
		push	hl
		exx
		push	de
		exx
		ld	hl, (keeper_hl)

		ret

keeper_hl:
		dw 0

; -------------------------------------

pop_regs:
		pop	iy
		pop	ix
		pop	bc
		pop	de
		pop	hl

		ret
