process_spell:
		PUSH_REGS

		ld	hl, GAME_VARIABLES + VAR_4B
		ld	b, 3
		call	nullify_buffer
		ld	de, SPELL_NAMES
		ld	b, a
		ld	c, a

check_entered_spell:
		ld	hl, TEXT_BUFFER

loop_spell_letters:
		ld	a, (de)
		or	a
		jp	m, get_spell_level		; jump if bit 7	is set

		cp	(hl)
		inc	hl
		jr	nz, go_to_next_spell

		call	next_spell_letter
		jr	c, loop_spell_letters

		ld	a, (GAME_VARIABLES + VAR_SPELL_CLASS)

		cp	2
		jr	nc, loc_6B91

		xor	1
		ld	(GAME_VARIABLES + VAR_SPELL_CLASS), a

loc_6B91:
		ld	(iy+VAR_4B), b
		inc	(iy+VAR_SPELL_LEVEL)

		ret
; -------------------------------------

go_to_next_spell:
		call	next_spell_letter
		jr	c, go_to_next_spell

		ld	c, 0
		inc	b

		jr	check_entered_spell
; -------------------------------------

get_spell_level:
		and	0Fh
		ld	(GAME_VARIABLES + VAR_SPELL_LEVEL), a
		jr	nz, loc_6BB5

		inc	(iy+VAR_SPELL_CLASS)
		ld	a, (GAME_VARIABLES + VAR_SPELL_CLASS)

		cp	4
		jr	c, loc_6BB5

		scf

		ret
; -------------------------------------

loc_6BB5:
		call	next_spell_letter
		ld	c, 0

		jr	check_entered_spell

next_spell_letter:
		inc	de
		inc	c
		ld	a, c

		cp	4		; length of spell

		ret
