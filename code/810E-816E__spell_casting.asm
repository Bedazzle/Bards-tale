; --- spell_casting --------------------------------------------
; @done
; Entry for a hero casting the currently-selected spell. Prints the
; caster's name and an intro line, then falls through to the shared
; spell-resolution code: the 'Z'/'[' light spells print "makes a
; light", letters 'O'..'Y' return without casting, and all others
; print "casts a spell".
; In:  ix = caster, VAR_CURRENT_SPELL = spell letter, iy = game vars
spell_casting:
		PRINT_NEWLINE

		PRINT_IX_HERO_NAME

		ld	a,(GAME_VARIABLES + VAR_CURRENT_SPELL)

		cp	$4F 			; 'O'
		jr	c,.cast_spell

		cp	$5A 			; 'Z'
		ret	c

		cp	$5C 			; '\'
		jr	nc,.cast_spell

		PRINT_MESSAGE	$5B			; "makes a light"

		jr	.to_resolve
; -------------------------------------

.cast_spell:
		PRINT_MESSAGE	$5C			; "casts a spell"

.to_resolve:
		jr	casts_a_spell.resolve

; ======= S U B	R O U T	I N E =========


; --- do_cast_spell -------------------------------------------------
; @done
; Casts the current spell (casts_a_spell) and then chains into the
; level's dynamic handler change_combat_speed — the variant used when a cast
; is followed by another scripted effect.
; In:  ix = caster, VAR_CURRENT_SPELL = spell letter, iy = game vars
do_cast_spell:
		call	casts_a_spell

		jp	change_combat_speed

; -------------------------------------

; --- casts_a_spell --------------------------------------------
; @done
; Announces "casts a spell", charges the caster's spell points
; (skipped for a monster / when no hero is active) and, on
; insufficient points, prints "but it fizzled!". Otherwise resolves
; the spell (.resolve): it maps the spell letter to a handler address
; via lookup tables $26/$25 and invokes it through a self-modified
; call, then shows the party stats. spell_casting jumps straight to
; .resolve to skip the spell-point charge.
; In:  ix = caster, VAR_CURRENT_SPELL = spell letter, iy = game vars
; Note: the call at .invoke_handler is patched with the handler
;       address (SMC).
casts_a_spell:
		PRINT_MESSAGE	$5C			; "casts a spell"

		GET_GAME_VARIABLE	VAR_ACTIVE_HERO

		jr	z,.resolve

		jr	c,.resolve

		call	spend_spell_points
		jr	c,print_fizzled

.resolve:
		ld	a,(GAME_VARIABLES + VAR_CURRENT_SPELL)
		ld	c,a

		cp	$4F ; 'O'
		jr	c,.clamp_spell

		sub	$0B

		cp	$51 ; 'Q'
		jr	c,.clamp_spell

		ld	a,$51 ; 'Q'

.clamp_spell:
		GET_A_FROM_TABLE	$26

		ld	b,a

		GET_B_FROM_TABLE	$25

		ld	l,a
		inc	b

		GET_B_FROM_TABLE	$25

		ld	h,a
		ld	(.invoke_handler+1),hl

		GET_C_FROM_TABLE	$4A

		ld	b,a

.invoke_handler:
		call	$					; !!! SMC
		jr	nc,jmp_print_stats

print_fizzled:
		PRINT_MESSAGE	$64			; "but it fizzled!"

jmp_print_stats:
		jp	print_stats_table
