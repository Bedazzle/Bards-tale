; --- BARD_TUNE_TABLE ------------------------------------------
; @done
; 6 bytes ($16,$11,$19,$0E,$1B,$14) — one tune id per bard song.
; Reached via ADDR_TABLE index $00 (___table_39), read by
; play_tune_prompt.
; Referenced by: play_tune_prompt (ADDR_TABLE index $00)
		; display "BARD_TUNE_TABLE: ", $
BARD_TUNE_TABLE:
		DB $16
		DB $11
		DB $19
		DB $0E
		DB $1B
		DB $14

; --- ___table_40 ---------------------------------------------
; @wip
; 16 bytes: $20,$1E,$1C,…,$10 — an even descending ramp (step -2),
; the shape of a per-step scaling/fade curve. EXHAUSTIVELY searched: no
; GET_*_FROM_TABLE $27, no GET_IY_A_FROM_TABLE two-index, no address ref
; in the shared engine, level 1 (City) OR level 2 (Cellars) - so its
; ADDR_TABLE slot $27 is unexercised by all carved code. Almost certainly
; read only by an un-carved dungeon level (3-17), or vestigial.
; Referenced by: ADDR_TABLE index $27 (no reader in any carved code)
		; display "___table_40: ", $
___table_40:
		DB $20
		DB $1E
		DB $1C
		DB $1A
		DB $18
		DB $16
		DB $14
		DB $12
		DB $10
		DB $0E
		DB $0C
		DB $0A
		DB 8
		DB 6
		DB 4
		DB 2

; --- ITEM_STATE_MARKERS ---------------------------------------
; @done
; Per-item-status marker character, 4 bytes indexed by the item's
; status nibble 0-3: $20 space (normal), $7C '|', $5E '^', $3F '?'.
; print_hero_items takes the item status (and $0F, or 3 when the top
; bit was set), reads ITEM_STATE_MARKERS[status] (GET_E_FROM_TABLE $3F)
; and PRINT_WITH_CODES draws it beside the item name in the inventory.
; Referenced by: print_hero_items / get_item_status (ADDR_TABLE index $3F)
ITEM_STATE_MARKERS:
		DB $20
		DB $7C
		DB $5E
		DB $3F

; --- CLASS_EQUIP_MASK ---------------------------------------------
; @done
; Per-class equipment bit, 10 bytes indexed by class 0-9
; ($80,$20,$40,$40,$40,$10,8,4,2,1 — classes 2-4 share bit $40).
; add_item_to_hero reads CLASS_EQUIP_MASK[hero class] and ANDs it with
; the item's ITEM_EQUIP class-mask (INX_ITEM_EQUIP); a non-zero result
; means the class may use the item, so it auto-equips.
; Referenced by: add_item_to_hero (ADDR_TABLE index $46)
CLASS_EQUIP_MASK:
		DB $80
		DB $20
		DB $40
		DB $40
		DB $40
		DB $10
		DB 8
		DB 4
		DB 2
		DB 1

; --- STAT_DISPLAY_TABLE ---------------------------------------
; @done
; 10 bytes — per-line field/column counts for the hero stats panel.
; Reached via ADDR_TABLE index $33 (___table_43), read by
; print_hero_stats.
; Referenced by: print_hero_stats (ADDR_TABLE index $33)
		; display "STAT_DISPLAY_TABLE: ", $
STAT_DISPLAY_TABLE:
		DB 1
		DB 2
		DB 2
		DB 2
		DB 2
		DB 5
		DB 1
		DB 1
		DB 1
		DB $0A

; --- POW10_TABLE ----------------------------------------------
; @done
; Decimal place-value table: 5 x DW (little-endian) = 1, 10, 100,
; 1000, 10000. binary_to_decimal reads it from the TOP (POW10_TABLE+9,
; the high byte of 10000) downward, subtracting each power to derive
; one decimal digit per place.
; Referenced by: binary_to_decimal
POW10_TABLE:
		DB 1
		DB 0
		DB $0A
		DB 0
		DB $64
		DB 0
		DB $E8
		DB 3
		DB $10
		DB $27

; --- RACE_STAT_BASE -------------------------------------------
; @done
; Per-race starting-stat bases: 7 races x 5 stats (ST,IQ,DX,CN,LK),
; 35 bytes, race r at offset 5*r. calculate_race reads a race's 5
; bases (index 5*race+4 down to 5*race), adds RND(0-6) to each and
; caps at 18 to roll the new hero's starting stats.
; Referenced by: calculate_race (ADDR_TABLE index $04, GET_C_FROM_TABLE)
		; display "RACE_STAT_BASE: ", $
RACE_STAT_BASE:
		DB $0A
		DB 6
		DB 8
		DB 8
		DB 5
		DB 8
		DB 9
		DB 9
		DB 6
		DB 6
		DB $0C
		DB 6
		DB 7
		DB $0A
		DB 3
		DB 4
		DB 6
		DB $0C
		DB 5
		DB $0A
		DB 9
		DB 8
		DB 9
		DB 7
		DB 6
		DB $0B
		DB 3
		DB 8
		DB $0B
		DB 4
		DB 9
		DB $0A
		DB 7
		DB 3
		DB 4

; --- KEY_CODES_TABLE ------------------------------------------
; @done
; 2-byte header (7,8 = rows,cols?) followed by 4 rows x 4 keyboard
; scan/character codes ($23,$24,$25,$26 / $34,$35,$36,$37 / …) — the
; on-screen key-grid codes. Reached via ADDR_TABLE index $14.
; Referenced by: ADDR_TABLE index $14 (KEY_CODES_TABLE)
		; display "KEY_CODES_TABLE: ", $
KEY_CODES_TABLE:
		DB 7
		DB 8
		DB $23,$24,$25,$26
		DB $34,$35,$36,$37
		DB $43,$44,$45,$46
		DB $50,$51,$52,$53

; --- ___table_46 ---------------------------------------------
; @wip
; 18 bytes cycling $15,$16,$17,$18 - values in the picture-id range, so
; likely an animation frame sequence (4 frames repeated). EXHAUSTIVELY
; searched: no GET_*_FROM_TABLE $15, no two-index, no address ref in the
; shared engine, level 1 or level 2 - its ADDR_TABLE slot $15 is
; unexercised by all carved code. Likely read only by an un-carved dungeon
; level (3-17), or vestigial.
; Referenced by: ADDR_TABLE index $15 (no reader in any carved code)
		; display "___table_46: ", $
___table_46:
		DB $15
		DB $16
		DB $15
		DB $16
		DB $17
		DB $18
		DB $15
		DB $16
		DB $17
		DB $18
		DB $15
		DB $16
		DB $17
		DB $18
		DB $15
		DB $16
		DB $17
		DB $18

; --- XP_CLASS_THRESHOLDS --------------------------------------
; @done
; Per-class experience thresholds, 13 entries per class (one per level
; 1-13) laid out class-major: calc_xp_for_level indexes it by
; class*13 + level (GET_A_FROM_TABLE $49) to fetch the BCD XP a hero of
; that class needs for that level; for levels above 13 it takes the
; 13th (level-12) entry and adds $15 (21) of BCD XP per further level.
; Each class block starts with a 0. Values are BCD digit pairs the
; store_bcd_and_compare / add_to_bcd_number helpers fold into the
; 12-digit comparison against CHAR_EXP.
; Referenced by: calc_xp_for_level (ADDR_TABLE index $49)
		; display "XP_CLASS_THRESHOLDS: ", $
XP_CLASS_THRESHOLDS:
		DB 0
		DB $13
		DB $23
		DB $3B
		DB $53
		DB $7B
		DB $14
		DB $1C
		DB $2C
		DB $44
		DB $5C
		DB $7C
		DB $15
		DB 0
		DB $14
		DB $2C
		DB $44
		DB $64
		DB $84
		DB $15
		DB $CC
		DB $1D
		DB $25
		DB $35
		DB $4D
		DB $6D
		DB 0
		DB $3B
		DB $7B
		DB $CB
		DB $24
		DB $34
		DB $44
		DB $0D
		DB $6C
		DB $8C
		DB $B4
		DB $1D
		DB $25
		DB 0
		DB $92
		DB $23
		DB $33
		DB $0C
		DB $73
		DB $9B
		DB $EB
		DB $2C
		DB $4C
		DB $64
		DB $8C
		DB $BC
		DB 0
		DB $92
		DB $23
		DB $33
		DB $0C
		DB $73
		DB $9B
		DB $EB
		DB $2C
		DB $4C
		DB $64
		DB $8C
		DB $BC
		DB 0
		DB $13
		DB $23
		DB $3B
		DB $53
		DB $7B
		DB $14
		DB $1C
		DB $2C
		DB $44
		DB $5C
		DB $7C
		DB $15
		DB 0
		DB $13
		DB $23
		DB $3B
		DB $53
		DB $7B
		DB $14
		DB $1C
		DB $2C
		DB $44
		DB $5C
		DB $7C
		DB $15
		DB 0
		DB $13
		DB $23
		DB $3B
		DB $53
		DB $7B
		DB $14
		DB $1C
		DB $2C
		DB $44
		DB $5C
		DB $7C
		DB $15
		DB 0
		DB $13
		DB $23
		DB $3B
		DB $53
		DB $7B
		DB $14
		DB $1C
		DB $2C
		DB $44
		DB $5C
		DB $7C
		DB $15
		DB 0
		DB $92
		DB $23
		DB $33
		DB $0C
		DB $73
		DB $9B
		DB $EB
		DB $2C
		DB $4C
		DB $64
		DB $8C
		DB $BC
		; display "XP_CLASS_THRESHOLDS end: ", $-1
