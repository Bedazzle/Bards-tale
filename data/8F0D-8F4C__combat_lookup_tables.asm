; --- RND_RANGE_MASKS ------------------------------------------
; @done
; 8 bytes: 1,3,7,$0F,$1F,$3F,$7F,$FF — a low-N-bits-set mask ladder
; (N=1..8). Used to reduce a random byte to a power-of-2 range: the
; caller reads mask[n] via ADDR_TABLE index $64 and ANDs it with the
; RNG hi byte (calc_monster_hp: and (iy+VAR_RND_HI); generate_encounter
; masks the encounter quantity likewise).
; Referenced by: calc_monster_hp, generate_encounter (ADDR_TABLE index $64)
RND_RANGE_MASKS:
		DB 1
		DB 3
		DB 7
		DB $0F
		DB $1F
		DB $3F
		DB $7F
		DB $FF
		
; --- OPTION_AVAIL_MASK ----------------------------------------
; @done
; Per-battle-option availability requirement, 7 bytes (1,0,2,0,4,8,0)
; indexed by the chosen option. option_is_found reads
; OPTION_AVAIL_MASK[option] (GET_E_FROM_TABLE $39): a 0 entry means the
; option is always allowed; otherwise the value is ANDed with the
; round's availability mask (c) and the option is rejected if the AND
; is zero.
; Referenced by: option_is_found (ADDR_TABLE index $39)
OPTION_AVAIL_MASK:
		DB 1
		DB 0
		DB 2
		DB 0
		DB 4
		DB 8
		DB 0

; --- GOLD_ROLL_MASK_HI ----------------------------------------
; @done
; Gold-drop mask ladder ($3F,$7F,$FF x6), 8 entries indexed by
; VAR_COPY_DAYPART (0-7). enemies_killed rolls the gold a kill yields:
; GET_IY_A_FROM_TABLE $54,$29 fetches GOLD_ROLL_MASK_HI[VAR_COPY_DAYPART]
; and ANDs it with VAR_RND_HI to form one byte of VAR_GOLD_FOUND_HI
; (GOLD_ROLL_MASK_LO $28 masks VAR_RND_LO for the other byte). The mask
; saturates to $FF quickly so later dayparts allow the full random range.
; Referenced by: enemies_killed (ADDR_TABLE index $29, sub-idx VAR_COPY_DAYPART)
GOLD_ROLL_MASK_HI:
		DB $3F
		DB $7F
		DB $FF
		DB $FF
		DB $FF
		DB $FF
		DB $FF
		DB $FF
		
; --- GOLD_ROLL_MASK_LO ----------------------------------------
; @done
; Gold-drop mask ladder (0,0,0,1,1,3,3,7), 8 entries indexed by
; VAR_COPY_DAYPART (0-7). In the same gold roll (enemies_killed), a
; GET_IY_A_FROM_TABLE $54,$28 fetches GOLD_ROLL_MASK_LO[VAR_COPY_DAYPART]
; and ANDs it with VAR_RND_LO for the companion byte of VAR_GOLD_FOUND_HI
; (0 for the first few dayparts = little/no low-order gold, rising to 7).
; Referenced by: enemies_killed (ADDR_TABLE index $28, sub-idx VAR_COPY_DAYPART)
GOLD_ROLL_MASK_LO:
		DB 0
		DB 0
		DB 0
		DB 1
		DB 1
		DB 3
		DB 3
		DB 7

; --- CLASS_AC_BONUS -------------------------------------------
; @done
; Per-class armour-class bonus, 10 bytes indexed by class 0-9
; (1,3,2,2,2,1,1,3,1,1). calc_defense_rating adds this to a hero's
; defense rating for NON-paladin classes (paladins use
; PALADIN_AC_BY_LEVEL at $3D instead, so entry 7 is unused).
; Referenced by: calc_defense_rating (ADDR_TABLE index $3E)
CLASS_AC_BONUS:
		DB 1
		DB 3
		DB 2
		DB 2
		DB 2
		DB 1
		DB 1
		DB 3
		DB 1
		DB 1

; --- PALADIN_AC_BY_LEVEL --------------------------------------
; @done
; Paladin armour-class bonus by level, 16 bytes indexed by paladin
; level 0-15 (1,1,2,2,2,3,3,3,3,4,4,4,4,5,5,6 - rises with level).
; calc_defense_rating uses this (instead of CLASS_AC_BONUS) when the
; hero is a Paladin, with level capped at 15.
; Referenced by: calc_defense_rating (ADDR_TABLE index $3D)
PALADIN_AC_BY_LEVEL:
		DB 1
		DB 1
		DB 2
		DB 2
		DB 2
		DB 3
		DB 3
		DB 3
		DB 3
		DB 4
		DB 4
		DB 4
		DB 4
		DB 5
		DB 5
		DB 6

; --- (unlabeled action-command key letters @ $8F46) ----------
; @done
; 7 ASCII bytes = the combat action-menu command keys, indexed
; 0..6. This is the head of the OPTION_KEYS list; the DB 0
; terminator that follows in BT_game.asm ("OPTION_KEYS:") closes it.
		DB 'A'			; 0 = (A)ttack foes
		DB 'D'			; 1 = (D)efend ??? not used in search_option loop #690B
		DB 'C'			; 2 = (C)ast spell
		DB 'U'			; 3 = (U)se item ??? not used in search_option loop #690B
		DB 'H'			; 4 = (H)ide in	shadows
		DB 'B'			; 5 = (B)ard song
		DB 'P'			; 6 = (P)arty attack
