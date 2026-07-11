; --- DAYPART_ROLL_ADD -----------------------------------------
; @done
; Additive base paired with DAYPART_ROLL_MASK ($4F) for the same
; daypart-scaled combat "quantity" rolls, 8 bytes ($00,$08,$08,$10,$20,
; $30,$40,$50) indexed by VAR_COPY_DAYPART (0-7). Read via
; GET_IY_A_FROM_TABLE $54,$50 (param1 $54 = VAR_COPY_DAYPART sub-index) -
; hence no plain GET_*_FROM_TABLE $50. Combined as (rnd & DAYPART_ROLL_MASK)
; + DAYPART_ROLL_ADD to give the enemy-group count (generate_encounter) or
; the item-drop roll (enemies_killed); the base grows with the daypart.
; (Static game table living in the reclaimed $5C00 sysvar RAM - NOT runtime
; state as first guessed.)
; Referenced by: generate_encounter, enemies_killed (ADDR_TABLE index $50, sub-idx VAR_COPY_DAYPART)
DAYPART_ROLL_ADD:
		DW $0800	; 5C5E
		DW $1008
		DW $3020
		DW $5040
