; --- ___table_27 ---------------------------------------------
; @wip
; 2 bytes ($14,$FF; $FF = end sentinel). Read via ADDR_TABLE index
; $5B (no direct consumer found in the cross-ref).
; Note: exact record format not yet reverse-engineered.
; Referenced by: ADDR_TABLE index $5B
		debug "___table_27: "
___table_27:
		DB $14
		DB $FF
		
; --- ___table_28 ---------------------------------------------
; @wip
; 1 byte (2). Read via ADDR_TABLE index $59 (no direct consumer
; found in the cross-ref).
; Note: single-value table; role not yet reverse-engineered.
; Referenced by: ADDR_TABLE index $59
		debug "___table_28: "
___table_28:
		DB 2

; --- ___table_29 ---------------------------------------------
; @done
; 1 byte (1). Read via ADDR_TABLE index $22 by age_effect_22 and
; mod_stat_22 (a stat-22 aging/modifier constant).
; Referenced by: ADDR_TABLE index $22
		debug "___table_29: "
___table_29:
		DB 1

; --- ___table_30 ---------------------------------------------
; @done
; 3 bytes (1,5,1). Read via ADDR_TABLE index $21 by age_effect_21
; and mod_stat_21 (a stat-21 aging/modifier triple).
; Referenced by: ADDR_TABLE index $21
		debug "___table_30: "
___table_30:
		DB 1
		DB 5
		DB 1

; --- ___table_31 ---------------------------------------------
; @done
; 3 bytes (1,4,3). Read via ADDR_TABLE index $5D by mod_stat_5D
; (a stat-5D modifier triple).
; Referenced by: ADDR_TABLE index $5D
		debug "___table_31: "
___table_31:
		DB 1
		DB 4
		DB 3

; --- SPELL_AC_DELTA ---------------------------------------------
; @done
; Per-spell armour-class delta, 2 bytes (1,3) indexed by the spell's
; handler parameter. spell_ac_modifier reads SPELL_AC_DELTA[param]
; (GET_B_FROM_TABLE $20) and applies it to the target's / enemy group's
; AC; the same value doubles as the aging delta on the effect tick.
; Referenced by: spell_ac_modifier (ADDR_TABLE index $20)
		debug "SPELL_AC_DELTA: "
SPELL_AC_DELTA:
		DB 1
		DB 3

; --- SPELL_ATTACK_BONUS ---------------------------------------------
; @done
; Per-spell to-hit bonus amount, 3 bytes (4,$0A,7) indexed by the
; spell's handler parameter (b, from SPELL_HANDLER_PARAM). spell_attack_bonus
; reads SPELL_ATTACK_BONUS[param] (GET_B_FROM_TABLE $5C) into c and adds it
; to the target's attack field via add_attack_bonus.
; Referenced by: spell_attack_bonus (ADDR_TABLE index $5C)
		debug "SPELL_ATTACK_BONUS: "
SPELL_ATTACK_BONUS:
		DB 4
		DB $0A
		DB 7

; --- DICE_SIDES_TABLE ---------------------------------------------
; @done
; 8 bytes: 1,2,4,6,8,10,16,20 — the standard RPG dice-sides set
; (d2,d4,d6,d8,d10,d16,d20). Read via ADDR_TABLE index $4B by
; cast_spell, check_spell_cost, no_combat_spell, poisoned_char and
; spell_heal_and_cure (dice type indexed by a spell's damage code).
; Referenced by: ADDR_TABLE index $4B
		debug "DICE_SIDES_TABLE: "
DICE_SIDES_TABLE:			; dice rolls table?
		DB 1		; 1
		DB 2		; 2
		DB 4		; 4
		DB 6		; 6
		DB 8		; 8
		DB $0A		; 10
		DB $10		; 16
		DB $14		; 20

; --- SUMMON_DATA ----------------------------------------------
; @wip
; Summonable-ally records, each 21 bytes: 5 leading stat/AC/HP-ish
; bytes, a 15-char space-padded name ("Dummy", "Joe the Sword",
; "Thor"), then a trailing block; list closed by an $FF-led record.
; This is the ally template data conjured by the summon spells
; (spell_summon_monster / summon_ally / finish_summon).
; Note: exact field layout not yet fully reverse-engineered.
		debug "SUMMON_DATA: "
SUMMON_DATA:
		DB 8
		DB $95
		DB $22
		DB $95
		DB $3C
		DB $95
		DB "Dummy          "
		DB $FF
		DB 0
		DB $FF
		DB $FF
		DB $FF
		DB $FF

		DB 1
		DB 0
		DB $0B
		DB 3
		DB 1
		DB "Joe the Sword  "
		DB $FF
		DB 0
		DB 0
		DB 0
		DB 0
		DB 0

		DB 5
		DB 0
		DB $0D
		DB 0
		DB $14
		DB "Thor           "
		DB $FF
		DB 0
		DB 0
		DB 0
		DB 0
		DB 0

		DB $FF
		DB 0
		DB $14
		DB $3F
		DB $80
