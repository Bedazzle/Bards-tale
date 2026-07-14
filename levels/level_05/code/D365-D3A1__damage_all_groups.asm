; --- damage_all_groups ($D365-$D3A1) ----------------------------------
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
special_dispatch_table:
		db $08,$20,$18,$D3,$10,$40,$30,$D3	; . ...@0.
		db $08,$60,$45,$D3,$08,$80,$BE,$D2	; .`E.....
		db $08,$90,$CE,$D2,$10,$A0,$F6,$D2	; ........
		db $08,$C0,$FB,$D2,$08,$D0,$00,$D3	; ........
		db $08,$E0,$05,$D3,$08,$F0,$D8,$D2	; ........
