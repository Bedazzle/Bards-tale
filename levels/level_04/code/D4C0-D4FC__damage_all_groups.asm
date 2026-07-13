; --- damage_all_groups ($D4C0-$D4FC) -----------------------
; @done
; Damage all 6 enemy groups; trailing data = special_dispatch_table ($D48B) + a record pointer table.
; Applies the rolled damage to all 6 enemy groups (uses $5FFF)

damage_all_groups:
		xor	a
		ld	h,a
		ld	(damage_type),a
		ld	a,(copy_daypart)
		inc	a
		ld	l,a
		ld	b,6
.loop:
		ld	a,b
		call	apply_damage_to_group
		djnz	.loop
		jp	print_stats_table

		db $08,$20,$73,$D4,$10,$40,$8B,$D4	; . s..@..
		db $08,$60,$A0,$D4,$08,$80,$19,$D4	; .`......
		db $08,$90,$29,$D4,$10,$A0,$51,$D4	; ..)...Q.
		db $08,$C0,$56,$D4,$08,$D0,$5B,$D4	; ..V...[.
		db $08,$E0,$60,$D4,$08,$F0,$33,$D4	; ..`...3.
