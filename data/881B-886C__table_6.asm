; --- SPELL_HANDLER_INDEX --------------------------------------
; @done
; Spell-code -> handler-selector table, 82 bytes indexed by the
; normalised spell code (0..$51). casts_a_spell.resolve reads
; SPELL_HANDLER_INDEX[code] (GET_A_FROM_TABLE $26) to get a byte offset
; into PROCS_2 (ADDR_TABLE index $25, the spell/action handler-address
; table); it then reads the two-byte handler address from PROCS_2 at
; that offset and offset+1 and SMC-patches it into the dispatch call.
; Values are therefore even (2 bytes per handler entry).
; Referenced by: casts_a_spell (ADDR_TABLE index $26)
SPELL_HANDLER_INDEX:
		DB 0
		DB 2
		DB 4
		DB 6
		DB 8
		DB $0A
		DB $0C
		DB $0E
		DB $10
		DB 0
		DB $12
		DB $14
		DB $16
		DB $0E
		DB $36
		DB 0
		DB $0C
		DB $14
		DB $16
		DB $12
		DB $0E
		DB $1A
		DB 2
		DB $1C
		DB $1E
		DB $10
		DB $20
		DB $16
		DB 2
		DB $22
		DB $16
		DB 4
		DB $1E
		DB $22
		DB 0
		DB $16
		DB $1C
		DB $16
		DB $20
		DB $24
		DB $16
		DB $18
		DB $16
		DB $1E
		DB $26
		DB 4
		DB 0
		DB $28
		DB $32
		DB $38
		DB $26
		DB $1E
		DB $2A
		DB $0C
		DB $1C
		DB $14
		DB $2C
		DB $14
		DB 0
		DB $2E
		DB $16
		DB $18
		DB $30
		DB $2A
		DB $0E
		DB $18
		DB $16
		DB $32
		DB $16
		DB $32
		DB $16
		DB $0E
		DB $16
		DB $18
		DB $34
		DB $32
		DB $16
		DB $0E
		DB $16
		DB 0
		DB 0
		DB $16
