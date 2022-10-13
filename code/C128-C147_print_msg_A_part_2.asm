loc_C128:
		pop	af
		dec	d
		inc	d

		jr	z, loc_C146

; ======= S U B	R O U T	I N E =========


sub_C12D:
		ld	hl, sentence
		ex	af, af'
		or	a
		jr	z, print_from_buffer

		ex	af, af'
		push	bc
		ld	bc, (GAME_VARIABLES + VAR_72)

loc_C13A:
		ld	a, (hl)
		ld	(bc), a
		inc	hl
		inc	bc
		dec	d
		jr	nz, loc_C13A

		ld	(GAME_VARIABLES + VAR_72), bc
		pop	bc

loc_C146:
		and	a

		ret
