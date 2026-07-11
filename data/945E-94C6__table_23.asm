; --- SPELL_HANDLER_PARAM --------------------------------------
; @done
; Per-spell/song handler argument, 105 bytes indexed by code. The B
; register passed to a spell/song handler is loaded from here:
; casts_a_spell reads SPELL_HANDLER_PARAM[spell code] (GET_C_FROM_TABLE
; $4A) into B before the SMC dispatch call; play_song reads
; SPELL_HANDLER_PARAM[song id + 7] (GET_A_FROM_TABLE $4A) into B before
; jumping to light_the_light. High-bit entries ($80-$8F) flag handler
; variants. (Old note "relates to MAFL" = the Mage Flame light param.)
; Referenced by: casts_a_spell, play_song (ADDR_TABLE index $4A)
		debug "SPELL_HANDLER_PARAM: "
SPELL_HANDLER_PARAM:
		DB 0,1,0,0		; relates to MAFL - table look up?
		DB 0,$28,0,2
		DB 0,1,0,4
		DB 0,6,1,2
		DB 1,8,1,1
		DB $86,0,2,0
		DB $14,0,1,$82
		DB 3,0,$80,1
		DB $3C,1,3,$83
		DB 1,$81,$FF,$0A
		DB $84,3,$85,$FF
		DB 1,2,4,0
		DB 6,4,2,$14
		DB $28,2,2,6
		DB $0C,8,5,0
		DB 6,6,0,$FF
		DB $8F,7,$47,$10
		DB 9,$20,$4A,0
		DB $0C,5,0,$20
		DB $4D,0,$4F,$18
		DB $20,$28,$30,$22
		DB $2C,$40,$48,$10
		DB $12,$14,6,7
		DB $11,$12,$13,$14
		DB $15,$16,$17,$18
		DB $19,$1A,$1B,$1C
		DB $1D						; 105 total