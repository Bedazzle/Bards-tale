; --- MONST_HP_ENC ---------------------------------------------
; @wip
; Nibble-packed per-monster HP/tier spec at the head of the monster-data
; region ($8F4E), $FC-RLE like the sibling tables. Each byte = {hi nibble
; = tier/level 1-7, lo nibble = variance 0-6}: values climb $1x -> $7x by
; monster id (weak humanoids $12, up to $72 for the toughest). No STATIC
; GET_*_FROM_TABLE targets it, but a dynamic combat trace
; (tools/m8xxx/memwatch.html) caught it being read via the RST-10h
; dispatcher (lookup_addr_table $716F/$7192) during fights, so it IS live
; - reached through a computed/indirect index (its sibling MONST_HP_AC at
; $8FCE is the one calc_monster_hp reads by the named INX_MONST_HP_AC).
; Note: exact consumer + how the {tier,variance} feeds HP still to pin down.
MONST_HP_ENC:
		DB $12,$12,$22,$22,$21,$22,$21,$21,$22,$21,$21,$21,$22,$22,$21,$22
		DB $21,$22,$FC,6,$21,$32,$32,$32,$FC,4,$31,$32,$31,$31,$32,$32
		DB $32,$31,$32,$32,$31,$30,$42,$32,$32,$41,$42,$42,$42,$41,$FC,4
		DB $42,$41,$41,$42,$42,$41,$42,$42,$42,$41,$FC,5,$42,$41,$42,$41
		DB $52,$53,$52,$53,$52,$52,$52,$50,$52,$52,$52,$51,$52,$52,$53,$52
		DB $50,$51,$52,$53,$50,$52,$52,$62,$54,$15,$51,$64,$66,$61,$62,$52
		DB $52,$52,$53,$62,$62,$61,$61,$62,$61,$63,$64,$15,$62,$62,$70,$60
		DB $62,$62,$62,$66,$72,$72,$72,$71

; --- DAYPART_DMG_SCALE ----------------------------------------
; @done
; Daypart-scaled combat multiplier, 8 bytes (1,1,2,2,2,3,3,4) indexed by
; VAR_COPY_DAYPART (0-7). Read via the two-index macro
; GET_IY_A_FROM_TABLE $54,$43 (param1 $54 = the VAR_COPY_DAYPART sub-index,
; param2 $43 = this table) - which is why no plain GET_*_FROM_TABLE $43
; exists. generate_encounter uses it to scale VAR_BASE_DAMAGE for the
; encounter, and play_song uses it with the tune's spell id. So the deeper
; the daypart, the bigger the multiplier (1..4).
; Referenced by: generate_encounter, play_song (ADDR_TABLE index $43, sub-idx VAR_COPY_DAYPART)
DAYPART_DMG_SCALE:
		DB 1
		DB 1
		DB 2
		DB 2
		DB 2
		DB 3
		DB 3
		DB 4

; --- MONST_HP_AC ----------------------------------------------
; @done
; Per-monster HP-dice / armour-class table, one nibble-packed byte per
; monster id: hi nibble = hit-dice component (calc_monster_hp does
; divide_A_by_16), lo nibble = AC/defense component. $FC bytes are
; record/run markers walked by lookup_addr_table. Indexed by monster id
; via the RST 10h GET_*_FROM_TABLE dispatcher (ADDR_TABLE index $44,
; INX_MONST_HP_AC).
; Referenced by: calc_monster_hp, calc_attack_damage, summon_creature
;               (ADDR_TABLE index $44).
MONST_HP_AC:
		DB 0
		DB $40,$60,$21,$61,$22,$42,$21,$21,$63,$84,$84,$44,$43,$A4,$85,$A4
		DB $23,$C5,$C6,$C5,$23,$23,$23,$23,$46,$25,$26,$45,$86,$66,$86,$C6
		DB $C7,$A5,$25,$25,$25,$25,$86,$C6,$46,$87,$27,$E7,$E8,$28,$69,$28
		DB $48,$69,$29,$27,$27,$27,$67,$88,$89,$49,$89,$AA,$49,$CA,$EA,$4A
		DB $6B,$AA,$A9,$A9,$C9,$A9,$EB,$2B,$2A,$2A,$6A,$4B,$4B,$AC,$4A,$2B
		DB $2B,$2B,$4B,$6C,$6D,$4D,$4C,$6C,$8C,$4B,$2B,$4C,$4D,$8D,$2E,$CE
		DB $AF,$EF,$50,$2F,$50,$70,$ED,$ED,$ED,$CF,$50,$71,$30,$72,$D3,$2F
		DB $70,$B2,$B0,$91,$B3,$F4,$D3,$B2,$F4,$F3,$D3,$F4,$54,$F4,$14

; --- MONST_SPEC -----------------------------------------------
; @done
; Per-monster attack/special spec: ONE byte per monster (128 total),
; RLE-encoded ($FC,count,value; index $70 >= $67 -> lookup_addr_table
; expands it). Low 5 bits = an attack-type / damage-spec index (the value
; scales with monster tier, 0 for the weakest up to $1F), tested via
; CHECK_ITEM_MASK $70,$1F by enemy_group_advance / calc_combat_initiative;
; the high bits ($20/$80 seen) are extra special-ability flags.
; calc_enemy_attack reads MONST_SPEC[type] (GET_A_FROM_TABLE $70) into the
; damage calc, and build_creature_record copies it into the enemy record.
; Confirmed 128 entries = the same monster count as MONST_MAGIC.
; Note: exact bit meanings of the flags/index are partial
;       (format partial).
; Referenced by: calc_enemy_attack, summon_creature (ADDR_TABLE index $70).
MONST_SPEC:	
		DB 0
		DB 0,0,$FC,4,1,0,0,$FC,4,2,1,3,2,3,4,3
		DB 3,4,$FC,4,2,4,$24,3,4,5,$84,4,5,5,$FC,5
		DB 4,6,$26,7,6,8,7,7,7,8,7,7,8,$88,$FC,4
		DB 6,$0A,9,9,$0A,$6A,$0A,$0B,$0B,$0D,$6B,$0B,$FC,4,8,$0B
		DB $0C,$2B,$0C,$AB,$0C,$4D,$8E,$0C,$FC,4,$0A,$EE,$0F,$0F,$0E,$90
		DB $11,$D0,$30,$10,$12,$53,$74,$13,$13,$14,$14,$10,$17,$16,$10,$10
		DB $10,$13,$56,$18,$36,$59,$BB,$12,$15,$15,$15,$18,$1A,$F8,$1C,$1C
		DB $1E,$9D,$75,$B7,$15,$DF,$FF

MONST_IMAGE:
		DB 0
		DB 0,0,0,0,5,$0B,2,2,$0B,3,1,8,6,$0B,1,6
		DB $0A,$0B,1,3,2,2,2,2,1,8,5,6,$0B,3,$0B,1
		DB 0,5,2,2,2,2,5,8,$0A,3,$0B,$0B,6,$0B,4,9
		DB 0,1,3,2,2,2,2,$0A,6,4,4,$0C,$0C,$0B,4,$0A
		DB $0C,1,2,2,2,2,4,$0B,9,$0B,3,$0B,$0C,$0C,7,2
		DB 2,2,2,5,$0B,1,1,$0C,4,4,9,3,$0B,5,$0C,6
		DB $0C,7,1,3,4,$0B,2,2,2,$0C,3,$0B,9,5,$0C,2
		DB $0B,1,$0C,4,4,2,$0B,9,$0B,$0C,7,3,2,$0B,7

; --- XP_TABLE -------------------------------------------------
; @done
; Per-monster experience reward, indexed by monster id. Index $6D >= $67
; so the block is RLE-decoded ($FC,count,value) by lookup_addr_table into
; one value per monster id. enemies_killed reads XP_TABLE[id]
; (GET_C_FROM_TABLE $6D) and then scales by the id: for id < $10 the value
; IS the XP; for id >= $10 the value is the HIGH byte, i.e. XP = value*256
; (`ld d,e / ld e,0`). So the leading 16 literal bytes ($32,$3C,$46,$50..
; = 50,60,70,80.. XP) cover the weakest monsters 0-15, and the RLE runs
; that follow give the *256 tier for the tougher ids 16+. The award is
; multiplied by the kill count and pooled (see award_experience).
; Referenced by: enemies_killed (ADDR_TABLE index $6D, INX_XP_TABLE).
XP_TABLE:	
		DB $32,$3C,$46,$50,$50,$5A,$5A,$64,$64,$64,$6E,$78,$96,$B4,$C8,$DC
		DB 1,1,1,$FC,4,2,3,3,$FC,7,4,$FC,4,5,$FC,4
		DB 6,$FC,4,7,$FC,4,8,$FC,8,9,$FC,$10,$0A,$FC,$0C,$0B
		DB $FC,$0C,$0C,$FC,$0C,$0D,$FC,$10,$0E,$FC,4,$0F

; --- MONST_MAGIC ----------------------------------------------
; @done
; Per-monster spell list: a FIXED 4-slots-per-monster array, RLE-encoded
; ($FC,count,value; index $72 >= $67 so lookup_addr_table expands it).
; enemy_pick_spell reads MONST_MAGIC[type*4 + slot] one slot at a time
; (show_monster_magic; the caller forms hl = type*4 + slot) and casts the
; returned spell code; a 0 slot ends the list. Decoding all 128 monsters
; (241 raw -> 512 bytes) gives sensible caster loadouts - e.g. magicians
; {1,2}, sorcerers {3,$19,$13}, wizards {$1B,$B,$B}, samurai {$C,1,$19},
; ninjas {$D,4,$1B}; 70 of the 128 monster types cast, non-casters have
; all-zero slots. $FE = a breath/special-attack marker (stone giants,
; ogre magi). Decoded per-monster list: monsters.magic.decoded.txt.
; Referenced by: enemy_pick_spell / show_monster_magic (ADDR_TABLE index $72).
; Referenced by: ADDR_TABLE index $72 (enemy spell AI).
MONST_MAGIC:
		DB 0
		DB $FC,$1D,0,1,1,2,0,0,$19,$13,$FC,$31,0,1,2,3
		DB 0,$19,$13,$1B,0,$0B,$0B,$0C,0,1,$19,$22,$FC,$29,0,1
		DB 3,4,0,$1B,$1C,$1D,0,$0B,$0C,$0D,0,4,$1B,$22,$FC,$0E
		DB 0,$FE,$FE,$FC,$12,0,$57,$57,$FC,$11,0,3,4,5,0,$1B
		DB $1D,$1E,0,$0E,$10,$11,0,4,$1D,$23,$FC,$0E,0,$58,$58,$FC
		DB $0E,0,$59,$59,$FC,$0D,0,5,6,6,0,$1B,$1E,$1F,0,6
		DB $1D,$23,0,$10,$11,$12,0,0,$4F,$4F,$FC,$1B,0,$11,0,0
		DB 0,$14,0,9,8,7,0,$1D,$1C,$1F,0,$12,$15,$16,0,$25
		DB $24,$1F,$FC,$16,0,$50,$50,$FC,6,0,$1D,$0E,0,0,$FE,$FE
		DB $FC,7,0,$0D,0,0,0,$50,$FC,$0A,0,$20,$20,$FC,$0A,0
		DB $51,$51,$FC,5,0,$0A,9,9,0,$1F,$20,$21,0,$15,$16,$18
		DB $FC,$0D,0,$1E,$1F,$21,0,0,$24,$21,0,0,$25,$52,0,$25
		DB $26,$26,0,0,$20,7,0,0,0,$15,$FC,6,0,$53,$53,0
		DB 0,$54,$54,$26,$18,$21,$1F,$FC,6,0,$55,$55,$FC,$0B,0,$21
		DB 0,$26,$21,$0D,$26,$18,$21,$1F,0,0,$26,$56,0,0,$15,$15
