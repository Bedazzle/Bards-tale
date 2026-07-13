; --- damage_all_groups ($D476-$D4B2) ---------------------------
; @done
; Damage all 6 enemy groups; trailing data = special_dispatch_table ($D48B) + a record pointer table.
; Applies the rolled damage to all 6 enemy groups (uses $5FFF)

damage_all_groups:
		xor	a
		ld	h,a
		ld	(damage_type),a
		ld	a,(copy_daypart)
		inc	a
		ld	l,a			; hl = damage spec ($5FFF+1)
		ld	b,6			; all 6 groups
.loop:
		ld	a,b
		call	apply_damage_to_group
		djnz	.loop
		jp	print_stats_table

; --- special_dispatch_table ($D48B) --------------------------
; @done
; The 10 special-location partitions, scanned by dispatch_special_location
; (base = special_dispatch_table-4, indexed by entry 1..10). Each record:
; DB count (cells in the partition), DB cell_offset (into special_loc_list),
; DW handler (the ev_* event fired when the party stands on a matched cell).
special_dispatch_table:
		DB 8,$20  : DW ev_dispatch_smc
		DB 16,$40 : DW ev_set_flags
		DB 8,$60  : DW ev_teleport
		DB 8,$80  : DW ev_spin_facing
		DB 8,$90  : DW ev_smoke
		DB 16,$A0 : DW ev_damage_all
		DB 8,$C0  : DW ev_inc_2f
		DB 8,$D0  : DW ev_inc_3e
		DB 8,$E0  : DW ev_show_number
		DB 8,$F0  : DW ev_start_encounter
