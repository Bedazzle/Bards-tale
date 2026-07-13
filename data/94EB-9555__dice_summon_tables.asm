; --- ___table_27 ---------------------------------------------
; @wip
; 2 bytes ($14,$FF; $FF = end sentinel). EXHAUSTIVELY searched: no
; GET_*_FROM_TABLE $5B, no two-index, no address ref in the shared engine,
; level 1 or level 2 - its ADDR_TABLE slot $5B is unexercised by all carved
; code. Likely read only by an un-carved dungeon level (3-17), or vestigial.
; Referenced by: ADDR_TABLE index $5B (no reader in any carved code)
		debug "___table_27: "
___table_27:
		DB $14
		DB $FF
		
; --- ___table_28 ---------------------------------------------
; @wip
; 1 byte (2). EXHAUSTIVELY searched: no GET_*_FROM_TABLE $59, no two-index,
; no address ref in the shared engine, level 1 or level 2 - its ADDR_TABLE
; slot $59 is unexercised by all carved code. Likely read only by an
; un-carved dungeon level (3-17), or vestigial.
; Referenced by: ADDR_TABLE index $59 (no reader in any carved code)
		debug "___table_28: "
___table_28:
		DB 2

; --- MOD_STAT_22_AMOUNT ---------------------------------------------
; @done
; 1 byte (1). Read via ADDR_TABLE index $22 by age_effect_22 and
; mod_stat_22 (a stat-22 aging/modifier constant).
; Referenced by: ADDR_TABLE index $22
		debug "MOD_STAT_22_AMOUNT: "
MOD_STAT_22_AMOUNT:
		DB 1

; --- MOD_STAT_21_AMOUNT ---------------------------------------------
; @done
; 3 bytes (1,5,1). Read via ADDR_TABLE index $21 by age_effect_21
; and mod_stat_21 (a stat-21 aging/modifier triple).
; Referenced by: ADDR_TABLE index $21
		debug "MOD_STAT_21_AMOUNT: "
MOD_STAT_21_AMOUNT:
		DB 1
		DB 5
		DB 1

; --- MOD_STAT_5D_AMOUNT ---------------------------------------------
; @done
; 3 bytes (1,4,3). Read via ADDR_TABLE index $5D by mod_stat_5D
; (a stat-5D modifier triple).
; Referenced by: ADDR_TABLE index $5D
		debug "MOD_STAT_5D_AMOUNT: "
MOD_STAT_5D_AMOUNT:
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
; @done
; Summonable-creature templates for the weak-monster summon path.
; OPENS with a little-endian WORD POINTER TABLE ($9508,$9522,$953C = this
; block +6/+$20/+$3A), indexed by summon id*2, each pointing at one of the
; templates ('Dummy'/'Joe the Sword'/'Thor'). spell_summon_monster reads a
; pointer via GET_B_FROM_TABLE $63 (id, id+1) then LDIRs the template into
; the ENEMY record. Each template is the CHAR-record init image:
;   +$00..$0E  CHAR_NAME (15 chars, space-padded)
;   +$0F       CHAR_NAME_TERM ($FF)
;   +$10..$11  CHAR_PARAMS_HI/LO
;   +$12..$14  CHAR_SPEED / SAVED_STATS / EXP_START
;   +$15       CHAR_ATTACK_SPEC
;   +$16       CHAR_DEFENSE_SPEC
;   +$17       one more init byte (stored to the enemy record)
;   +$18..$19  HP dice spec {mask, base}: HP = (GET_RND_NUMBERS & mask) +
;              base, capped $FF (Dummy = 0 & mask + $0B = 11 HP).
; spell_summon_monster then zeroes the rest of the ENEMY record. The list
; ends with an $FF-led record.
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
