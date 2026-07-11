; --- BARKEEP_RUMORS --------------------------------------------
; @done
; Barkeep rumor table (22 bytes): message ids 0x85-0x8A (messages 133-138,
; the six tavern rumours), with $88 padding the tail. talk_barkeeper picks
; an entry with GET_RND_BY_PARAM 3 + tip offset, then GET_A_FROM_TABLE $0B
; and prints the resulting rumour message.
; Referenced by: ADDR_TABLE index $0B (read by talk_barkeeper).
BARKEEP_RUMORS:
		DB $85
		DB $85

		DB $86
		DB $86

		DB $87
		DB $87

		DB $88
		DB $88

		DB $89
		DB $89

		DB $8A
		DB $8A

		DB $88
		DB $88
		DB $88
		DB $88
		DB $88
		DB $88
		DB $88
		DB $88
