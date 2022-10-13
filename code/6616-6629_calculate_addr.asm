calc_in_FB7D:
		ld	hl, addr_FB7D

		jr	calculate_addr
; -------------------------------------

calc_in_FD7A:
		ld	hl, addr_FD7A

calculate_addr:
		push	de
		push	bc
		ld	de, 64h
		inc	b

loc_6624:
		add	hl, de
		djnz	loc_6624

		pop	bc
		pop	de

		ret
