loc_771C:
		PUSH_REGS

		call	sub_7728
		add	a, (hl)
		ld	(hl), a
		ld	hl, addr_FB4F

		jr	convert_12_digits

sub_7728:
		push	af
		and	7
		ld	b, a
		ld	a, 0Bh
		sub	b
		ld	b, a
		pop	af
		call	divide_A_by_8
		ld	hl, addr_FB4F
		inc	b

loc_7738:
		inc	hl
		djnz	loc_7738

		ret
