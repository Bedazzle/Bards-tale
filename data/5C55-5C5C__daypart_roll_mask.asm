; --- DAYPART_ROLL_MASK ----------------------------------------
; @done
; Daypart-scaled RNG mask for combat "quantity" rolls, 8 bytes
; ($0F,$0F,$1F,$1F,$1F,$1F,$1F,$1F) indexed by VAR_COPY_DAYPART (0-7).
; Read via the two-index macro GET_IY_A_FROM_TABLE $54,$4F (param1 $54 =
; the VAR_COPY_DAYPART sub-index, param2 $4F = this table) - hence no plain
; GET_*_FROM_TABLE $4F. The result is ANDed with a random byte to size a
; roll, paired with DAYPART_ROLL_ADD ($50) as the additive base:
;   generate_encounter -> the enemy-group count for the encounter;
;   enemies_killed      -> the item-drop roll.
; (Its address $5C55 falls in the reclaimed $5C00 sysvar RAM but it is a
; static game table, read as above - NOT runtime state as first guessed.)
; Referenced by: generate_encounter, enemies_killed (ADDR_TABLE index $4F, sub-idx VAR_COPY_DAYPART)
DAYPART_ROLL_MASK:
		DW $0F0F	; 5C56
		DW $1F1F
		DW $1F1F
		DW $1F1F
