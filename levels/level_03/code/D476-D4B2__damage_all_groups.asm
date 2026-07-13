; --- damage_all_groups ($D476-$D4B2) ---------------------------
; @wip
; Damage all 6 enemy groups; trailing data = special_dispatch_table ($D48B) + a record pointer table.

damage_all_groups:
		xor	a
		ld	h,a
		ld	(var_5FFB),a
		ld	a,(var_5FFF)
		inc	a
		ld	l,a
		ld	b,6
.d482:
		ld	a,b
		call	apply_damage_to_group
		djnz	.d482
		jp	print_stats_table
		db $08,$20,$29,$d4,$10,$40,$41,$d4	; . )..@A.
		db $08,$60,$56,$d4,$08,$80,$cf,$d3	; .`V.....
		db $08,$90,$df,$d3,$10,$a0,$07,$d4	; ........
		db $08,$c0,$0c,$d4,$08,$d0,$11,$d4	; ........
		db $08,$e0,$16,$d4,$08,$f0,$e9,$d3	; ........
