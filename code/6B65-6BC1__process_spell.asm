; --- process_spell ----------------------------------------
; @done
; Match the spell name typed into TEXT_BUFFER against the
; SPELL_NAMES table and, on a match, record the spell code, its
; class and level into VAR_CURRENT_SPELL / VAR_SPELL_CLASS /
; VAR_SPELL_LEVEL. Walks the table entry by entry, four letters
; per name, using bit-7 bytes as level / class markers.
; In:  a = starting table index, iy = game variables base
; Out: spell vars set; carry set if the name was not recognised
process_spell:
		PUSH_REGS

		ld	hl,GAME_VARIABLES + VAR_CURRENT_SPELL
		ld	b,3
		call	nullify_buffer
		ld	de,SPELL_NAMES
		ld	b,a
		ld	c,a

check_entered_spell:
		ld	hl,TEXT_BUFFER

loop_spell_letters:
		ld	a,(de)
		or	a
		jp	m,get_spell_level		; jump if bit 7	is set

		cp	(hl)
		inc	hl
		jr	nz,go_to_next_spell

		call	next_spell_letter
		jr	c,loop_spell_letters

		ld	a,(GAME_VARIABLES + VAR_SPELL_CLASS)

		cp	2
		jr	nc,.record_spell

		xor	1
		ld	(GAME_VARIABLES + VAR_SPELL_CLASS),a

.record_spell:
		ld	(iy+VAR_CURRENT_SPELL),b
		inc	(iy+VAR_SPELL_LEVEL)

		ret
; -------------------------------------

go_to_next_spell:
		call	next_spell_letter
		jr	c,go_to_next_spell

		ld	c,0
		inc	b

		jr	check_entered_spell
; -------------------------------------

get_spell_level:
		and	$0F
		ld	(GAME_VARIABLES + VAR_SPELL_LEVEL),a
		jr	nz,.next_entry

		inc	(iy+VAR_SPELL_CLASS)
		ld	a,(GAME_VARIABLES + VAR_SPELL_CLASS)

		cp	4
		jr	c,.next_entry

		scf

		ret
; -------------------------------------

.next_entry:
		call	next_spell_letter
		ld	c,0

		jr	check_entered_spell

; --- next_spell_letter ------------------------------------
; @done
; Advance to the next letter of the current spell name: bump the
; source pointer and letter counter, returning carry set while
; still within the 4-letter name (counter < 4).
; In:  de = spell-name pointer, c = letter index
; Out: de/c advanced; carry set if more letters remain
next_spell_letter:
		inc	de
		inc	c
		ld	a,c

		cp	4		; length of spell

		ret
