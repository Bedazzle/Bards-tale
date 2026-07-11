; --- SWAP_STAT_TEMPLATE ---------------------------------------
; @done
; 4-byte fixed template for a hero's CHAR_SAVED_STATS during the
; type-4 stat-swap damage effect. apply_damage_to_hero (.type4_swap)
; backs the hero's current CHAR_SAVED_STATS up into CHAR_SWAP_STATS and
; overwrites CHAR_SAVED_STATS with these 4 bytes (8,$41,8,$40, read via
; GET_B_FROM_TABLE $4E). compare_char_attrs later compares CHAR_SAVED_STATS
; against this template to detect whether the hero is still in the
; swapped state (before restoring the backed-up stats).
; Referenced by: apply_damage_to_hero, compare_char_attrs (ADDR_TABLE index $4E)
SWAP_STAT_TEMPLATE:
		DB 8
		DB $41
		DB 8
		DB $40
