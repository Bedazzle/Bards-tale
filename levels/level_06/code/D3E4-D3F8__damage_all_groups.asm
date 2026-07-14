; --- damage_all_groups ($D3E4-$D3F8) ----------------------------------
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
