spell_casting:
		PRINT_NEWLINE

		PRINT_IX_HERO_NAME

		ld	a, (GAME_VARIABLES + VAR_4B)

		cp	4Fh 			; 'O'
		jr	c, loc_8125

		cp	5Ah 			; 'Z'
		ret	c

		cp	5Ch 			; '\'
		jr	nc, loc_8125

		PRINT_MESSAGE	5Bh			; "makes a light"

		jr	loc_8128
; -------------------------------------

loc_8125:
		PRINT_MESSAGE	5Ch			; "casts a spell"

loc_8128:
		jr	loc_813F

; ======= S U B	R O U T	I N E =========


sub_812A:
		call	casts_a_spell

		jp	dyn_proc_54

; -------------------------------------

casts_a_spell:
		PRINT_MESSAGE	5Ch			; "casts a spell"

		GET_GAME_VARIABLE	VAR_ACTIVE_HERO

		jr	z, loc_813F

		jr	c, loc_813F

		call	loc_794D
		jr	c, print_fizzled

loc_813F:
		ld	a, (GAME_VARIABLES + VAR_4B)
		ld	c, a

		cp	4Fh ; 'O'
		jr	c, loc_814F

		sub	0Bh

		cp	51h ; 'Q'
		jr	c, loc_814F

		ld	a, 51h ; 'Q'

loc_814F:
		GET_A_FROM_TABLE	26h

		ld	b, a

		GET_B_FROM_TABLE	25h

		ld	l, a
		inc	b

		GET_B_FROM_TABLE	25h

		ld	h, a
		ld	(loc_8163+1), hl

		GET_C_FROM_TABLE	4Ah

		ld	b, a

loc_8163:
		call	$					; !!! SMC
		jr	nc, jmp_print_stats

print_fizzled:
		PRINT_MESSAGE	64h			; "but it fizzled!"

jmp_print_stats:
		jp	print_stats_table
