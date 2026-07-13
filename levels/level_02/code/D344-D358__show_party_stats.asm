; --- show_party_stats --------------------------------------
; @done
; Redraw the 6 party members' status rows (per-member via apply_damage_to_group, indexed by
; $5FFF+1) then the stats table. Called by the dungeon 'redraw' special event.
show_party_stats:
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
