; --- TEMPLE_HEAL_COST ------------------------------------------
; @done
; Temple base healing costs: 9 little-endian words (0, 400, 300, 900,
; 1120, 220, 500, 600, 900). proc_temple reads a word with two
; GET_H_FROM_TABLE $12 calls (h = 2*condition, then h+1) and multiplies it
; by the character level to price the cure.
; Referenced by: ADDR_TABLE index $12 (read by proc_temple).
TEMPLE_HEAL_COST:
		DB 0
		DB 0
		DB $90
		DB 1
		DB $2C
		DB 1
		DB $84
		DB 3
		DB $60
		DB 4
		DB $DC
		DB 0
		DB $F4
		DB 1
		DB $58
		DB 2
		DB $84
		DB 3
