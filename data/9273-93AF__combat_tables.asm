; --- AI_SPELL_CODES -------------------------------------------
; @done
; AI spell-selection -> spell code. When a computer-controlled caster
; (ally or enemy, in combat_foes) picks an action whose code is < $4F,
; that code indexes this table (GET_A_FROM_TABLE $35) and the result is
; stored into VAR_CURRENT_SPELL as the spell the caster will cast; a
; code >= $4F is already a spell letter and skips the lookup. Values are
; the resulting spell codes ($00..$4E).
; Referenced by: combat_foes (ally + enemy cast paths, ADDR_TABLE index $35)
AI_SPELL_CODES:
		DB 0
		DB 1
		DB 4
		DB 6
		DB 8
		DB $0B
		DB $0C
		DB $0E
		DB $10
		DB $11
		DB $12
		DB $0B
		DB $17
		DB $19
		DB $38
		DB $1D
		DB $1E
		DB $21
		DB $23
		DB $24
		DB $25
		DB $11
		DB $28
		DB $29
		DB $2A
		DB $31
		DB $34
		DB $35
		DB $36
		DB $37
		DB $38
		DB $39
		DB $3D
		DB $41
		DB $42
		DB $44
		DB $46
		DB $48
		DB $4E

; --- MONK_BAREHAND_DAMAGE -------------------------------------
; @done
; Monk barehand damage-spec by level. calc_attack_damage, for a Monk
; with no weapon, takes the monk's level/2 (capped at $1F) and reads
; MONK_BAREHAND_DAMAGE[level] (GET_A_FROM_TABLE $6C), then rolls that
; damage spec. Index $6C >= $67 so the block is RLE-decoded
; ($FC,count,value): higher-level monks hit for progressively bigger
; specs ($23,$24,$25,$26,$44,$45,$63..$66).
; Referenced by: calc_attack_damage (ADDR_TABLE index $6C)
MONK_BAREHAND_DAMAGE:
		DB 0
		DB 1
		DB 2
		DB 3
		DB 4
		DB $23
		DB $23
		DB $24
		DB $24
		DB $FC
		DB 4
		DB $25
		DB $26
		DB $26
		DB $26
		DB $FC
		DB 4
		DB $44
		DB $FC
		DB 4
		DB $45
		DB $63
		DB $63
		DB $63
		DB $64
		DB $64
		DB $64
		DB $65
		DB $66

; --- CLASS_TO_HIT_BONUS ---------------------------------------
; @done
; Per-class to-hit bonus, 10 bytes indexed by class 0-9
; (2,0,0,0,0,1,1,2,2,3 - Warrior/Paladin/Hunter/Monk hit best,
; spell casters worst). calc_attack_damage adds it to the hero's
; attack roll (ld a,CHAR_CLASS -> GET_A_FROM_TABLE $4C -> to-hit).
; Referenced by: calc_attack_damage (ADDR_TABLE index $4C)
CLASS_TO_HIT_BONUS:
		DB 2
		DB 0
		DB 0
		DB 0
		DB 0
		DB 1
		DB 1
		DB 2
		DB 2
		DB 3

; --- DAMAGE_DICE_MASK -----------------------------------------
; @wip
; Composite block. First 8 bytes are a bit-mask ladder
; (3,7,$0F,$1F,$3F,$7F,$FF,1 = 2^(n+2)-1): calc_attack_damage takes
; the weapon damage-spec's dice-count field (top 3 bits) as the index
; and uses the returned mask in the per-round damage roll.
; The later bytes (+8,+$B, formerly addr_92C9/92CC) are referenced
; separately for other purposes - not part of the mask ladder.
; Note: only the mask-ladder use is reverse-engineered; the rest is
;       unidentified data sharing this block.
; Referenced by: calc_attack_damage (ADDR_TABLE index $4D)
DAMAGE_DICE_MASK:
		DB 3
		DB 7
		DB $0F
		DB $1F
		DB $3F
		DB $7F
		DB $FF
		DB 1
		DB $45
		DB $30
		DB $2F
		DB $0A
		DB $14
		DB $1E
		DB $33
		DB $3C
		DB $41
		DB $58
		DB $5E
		DB $6B
		DB $6E
		DB $7C
		DB $4E
		DB $5F
		DB $6F
		DB $7E
		DB $FF
		DB $FF
		DB $FF
		DB $FF
		DB $FF
		DB $FF
		DB $FF
		
; --- COMBAT_SPEED_TABLE ---------------------------------------
; @done
; 32 bytes. First 16 = descending speed values (7,7,6,6,…,1); next
; 16 = a paced value ramp ($60,$5C,…,$24, step -4). Reached via
; ADDR_TABLE index $02 (___table_18), read by set_speed.
; Referenced by: set_speed (ADDR_TABLE index $02)
COMBAT_SPEED_TABLE:
		DB 7
		DB 7
		DB 6
		DB 6
		DB 5
		DB 5
		DB 4
		DB 4
		DB 3
		DB 3
		DB 2
		DB 2
		DB 1
		DB 1
		DB 1
		DB 1
		DB $60
		DB $5C
		DB $58
		DB $54
		DB $50
		DB $4C
		DB $48
		DB $44
		DB $40
		DB $3C
		DB $38
		DB $34
		DB $30
		DB $2C
		DB $28
		DB $24

; --- ATTACK_WORD_TABLE ----------------------------------------
; @done
; ~120 bytes of variable-length records separated by $FC sentinels
; ($FC = end-of-record). Selects the attack verb/word printed in
; combat. Reached via ADDR_TABLE index $74 (___table_19), read by
; print_attack_word.
; Referenced by: print_attack_word (ADDR_TABLE index $74)
ATTACK_WORD_TABLE:
		DB 0
		DB $FC
		DB 5
		DB 0
		DB 4
		DB $FC
		DB 4
		DB 0
		DB 2
		DB 0
		DB 3
		DB 3
		DB 0
		DB 0
		DB 3
		DB 1
		DB 0
		DB 0
		DB 6
		DB $FC
		DB 4
		DB 0
		DB 4
		DB 3
		DB 4
		DB 2
		DB 0
		DB 6
		DB 1
		DB 0
		DB 0
		DB 4
		DB $FC
		DB 4
		DB 0
		DB 4
		DB 3
		DB 1
		DB 0
		DB 5
		DB 0
		DB 2
		DB 1
		DB 2
		DB 6
		DB 0
		DB 4
		DB 6
		DB $FC
		DB 4
		DB 0
		DB 1
		DB 3
		DB 3
		DB 2
		DB 6
		DB 2
		DB 5
		DB 2
		DB 1
		DB 6
		DB $FC
		DB 5
		DB 0
		DB 2
		DB 5
		DB 7
		DB 0
		DB 0
		DB 1
		DB 6
		DB 2
		DB $FC
		DB 5
		DB 0
		DB 4
		DB 5
		DB 0
		DB 5
		DB 6
		DB 2
		DB 3
		DB 7
		DB 0
		DB 5
		DB 2
		DB 2
		DB 3
		DB 0
		DB 0
		DB 0
		DB 1
		DB 2
		DB 5
		DB 0
		DB 0
		DB 0
		DB 6
		DB 6
		DB 5
		DB 7
		DB 2
		DB 2
		DB 0
		DB 5
		DB 0
		DB 3
		DB 2
		DB 2
		DB 5
		DB 5
		DB 7
		DB 5
		DB 6
		DB 0
		DB 6
		DB 0
		DB 2
		DB 0

; --- ITEM_SPELL_CODES -----------------------------------------
; @done
; Item effect-code -> spell code, indexed by the item's effect code.
; use_item strips the code (and $7F, requires >= $10), then reads
; ITEM_SPELL_CODES[code] (GET_A_FROM_TABLE $6A) and stores it into
; VAR_CURRENT_SPELL, so the item casts that spell; option_is_found uses
; the same lookup for the combat "use item" option. Index $6A >= $67, so
; the block is RLE-decoded ($FC,count,value) by lookup_addr_table: the
; stored bytes below are the compressed form (e.g. 0,1,2,3,4 then
; $FC,$0C,0 = twelve 0 entries for the unused low codes, then the tail
; of real spell codes). The whole $9379-$93AF span is this one table.
; Referenced by: use_item, option_is_found (ADDR_TABLE index $6A)
ITEM_SPELL_CODES:
		DB 0
		DB 1
		DB 2
		DB 3
		DB 4
		DB $FC
		DB $0C
		DB 0
		DB 7
		DB $0B
		DB $0C
		DB $0F
		DB $12
		DB $13
		DB $14
		DB $15
		DB $22
		DB $26
		DB $27
		DB $2B
		DB $2F
		DB $33
		DB $37
		DB $3A
		DB $3E
		DB $3F
		DB $40
		DB $47
		DB $44
		DB $48
		DB $49
		DB $4A
		DB $4D
		DB $4E
		DB $57
		DB $59
		DB $4F
		DB $50
		DB $51
		DB $5A
		DB $5B
		DB $5C
		DB $5D
		DB $5E
		DB $5F
		DB $60
		DB $61
		DB $62
		DB $63
		DB $64
		DB $65
		DB $66
		DB $67
		DB $68
		DB $69
