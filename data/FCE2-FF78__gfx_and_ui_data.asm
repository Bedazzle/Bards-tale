; === FCE2-FF78 region ========================================
; A mixed block of screen-graphics fragments and UI text into which
; many ADDR_TABLE targets fall. Bytes read as 2-bit pixel nibbles
; ($AA,$50,$78,$FA,$FF) plus embedded ASCII strings (see ___table_9H:
; the combat-screen column header and the FOUND/SEARCHING/LOADING
; BARD status lines). Each ___table_NN label below is a real
; ADDR_TABLE entry (index + consumers noted), but the label sits
; inside this graphics/UI data, so the value-format is unverified.
;
; KEY FINDING (consumer analysis + dynamic trace, CONFIRMED): most of the
; ___table_9X ADDR_TABLE slots in this region are COMBAT WORKING BUFFERS /
; LISTS, not graphics - per-hero / per-enemy / per-group state arrays read
; via GET_*_FROM_LIST / GET_*_FROM_TABLE during a fight. A memory-watch
; trace (tools/m8xxx/memwatch.html) caught buffers $2A,$2B,$2C,$2D,$2E and
; ALLY_DATA ($2F) all being written by nullify_buffer ($6162) - i.e. they
; are ZEROED at combat setup, then read during the fight and cleared or
; rebuilt by post_combat_cleanup (.rebuild_lists walks $45,$30,$2F,...).
; (See the WRITE-TRACE REFINEMENT below: the populate side is unproven.)
; The static bytes below are therefore just power-on junk (they happen to
; read as gfx fill); the live content is runtime combat state. Roles from
; the consumers:
;   $56 -> per-hero queued combat action (dispatch_hero_action dispatches
;          on it: 1=melee,3=cast,4=cast/use,6=item,8=confused);
;   $40 -> per-hero status/hide flag (select_random_hero skips nonzero);
;   $2A/$2B -> hit-group id list + kill-count array (enemies_killed);
;   $2C/$2D/$2E -> per-enemy-group attack / AC / damage modifiers.
; Kept @wip (labels not renamed) because the exact per-buffer field layout
; still rests on consumer inference, but the BUFFER nature is confirmed.
;
; READ vs WRITE MECHANISM (2026-07-11, from code/8CCD get_from_table +
; write-trace over 44 city encounters):
;   * GET_*_FROM_TABLE idx  -> READS table[idx] into A (these FCE2 slots are
;     read as SOURCES here);
;   * GET_*_FROM_LIST  idx  -> COPIES table[idx] to (hl'), the *caller's*
;     shadow-HL destination (get_from_list: `call lookup; exx; ld (hl),a`).
; So in apply_damage_dispatch the `.mark_active` writes (`exx / ld (hl),a /
; inc (hl)`) go to the CALLER's hl' - the enemy-group record being compacted
; - NOT to these ADDR_TABLE slots. The slots themselves are only ZEROED (by
; nullify_buffer at setup) and READ; across 44 city encounters no non-nullify
; write hit $FD71-$FDDE, so in ordinary combat they read back ZERO = "no
; modifier / empty list" (default). The per-buffer "roles" below are the
; CONSUMER's interpretation of what a non-zero value WOULD mean; a populate
; path (a routine doing GET_*_FROM_LIST with hl' aimed here, or an
; encounter-setup writer for special monsters) was not observed in the trace.
; Note: static layout of this region not reverse-engineered (it is scratch).
;
; --- (unlabeled leading fragment @ $FCE2) --------------------
; @wip
; No label; ~26 bytes of pixel-nibble data preceding byte_FCFC.
		DB $AA
		DB $AA
		DB $FA
		DB $AA
		DB $72
		DB 0
		DB $F8
		DB $AA
		DB $AA
		DB $F8
		DB $AA
		DB $AA
		DB $AA
		DB 0
		DB $72
		DB $AA
		DB $A0
		DB $72
		DB $0A
		DB $AA
		DB $72
		DB 0
		DB $FA
		DB $50
		DB $50
		DB $50
; --- byte_FCFC ------------------------------------------------
; @done
; Pixel-nibble graphics fragment ($50/$AA/$FF/$78 …), 16 bytes/row.
; Plain byte label (not an ADDR_TABLE target).
byte_FCFC:	
		DB $50,$50,$50,0,$AA,$AA,$AA,$AA,$AA,$AA
		DB $72,0,$AA,$AA,$AA,$AA,$FA,$D8,$50,0
		DB $AA,$AA,$AA,$AA,$FA,$FA,$AA,0,$AA,$AA
		DB $D8,$50,$D8,$AA,$AA,0,$AA,$AA,$AA,$72
		DB $50,$50,$50,0,$FA,$0A,$4A,$D8,$E0,$A0
		DB $FA,0,$5A,$50,$50,$50,$50,$50,$5A,0
		DB 3,3,3,3,3,3,3,3,$5A,$0A
		DB $0A,$0A,$0A,$0A,$5A,0,$50,$82,$82,$D2
		DB $82,$82,$50,0,0,0,0,$FF,0,0
		DB 0,0,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
		DB 0,0,$7A,$AA,$AA,$AA,$7A,0,$A0,$A0
		DB $F8,$AA,$AA,$AA,$F8,0,0

; --- ___table_93 ---------------------------------------------
; @wip
; 7-byte fragment in the graphics/UI region. Read via ADDR_TABLE
; index $45 by post_combat_cleanup and recalc_party_ac.
; Note: value-format unverified (see region banner).
; Referenced by: ADDR_TABLE index $45
___table_93:	
		DB 0
		DB $78
		DB $AA
		DB $A0
		DB $AA
		DB $78
		DB 0

; --- ___table_94 ---------------------------------------------
; @wip
; 7-byte fragment in the graphics/UI region. Read via ADDR_TABLE
; index $30 by post_combat_cleanup and spell_attack_bonus.
; Note: value-format unverified (see region banner).
; Referenced by: ADDR_TABLE index $30
___table_94:
		DB $0A
		DB $0A
		DB $DA
		DB $AA
		DB $AA
		DB $AA
		DB $DA

; --- ALLY_DATA ------------------------------------------------
; @wip
; 7-byte fragment in the graphics/UI region. Reached via ADDR_TABLE
; index $2F (ALLY_DATA); no direct reader resolved in the cross-ref.
; Note: value-format unverified (see region banner).
; Referenced by: ADDR_TABLE index $2F
ALLY_DATA:
		DB 0,0,0,$D8,$AA,$FA,$A0

; --- ___table_96 ---------------------------------------------
; @wip
; 4 bytes = a per-enemy-group AC modifier, indexed by the enemy group
; 0-3. calc_enemy_attack reads it at VAR_ACTIVE_ENEMY and adds it into
; the to-hit/AC calc; spell_ac_modifier reads it at (target & $7F).
; CONFIRMED a runtime buffer: zeroed by nullify_buffer ($6162) at combat
; setup; in a 44-encounter trace it then read back ZERO (no non-nullify
; write hit it), so in ordinary combat the reader gets 0 = no modifier.
; Referenced by: calc_enemy_attack, spell_ac_modifier (ADDR_TABLE index $2D)
___table_96:
		DB $7A,0,$78,$AA
		
; --- ___table_9K ---------------------------------------------
; @wip
; 4-byte fragment. Read via ADDR_TABLE index $55 by calc_ac_worker,
; process_bard_song and spell_ac_modifier.
; Note: value-format unverified (see region banner).
; Referenced by: ADDR_TABLE index $55
___table_9K:
		DB $A0,$F0,$A0,$A0

; --- ___table_97 ---------------------------------------------
; @wip
; 4 bytes = a per-enemy-group attack/damage bonus, indexed by the enemy
; group 0-3. calc_attack_damage folds it into the damage roll; the
; spell_stat_modifiers entries (mod_stat_22 buff / mod_stat_5D debuff)
; read it at (target & $7F) to add/subtract an attack bonus.
; CONFIRMED a runtime buffer: zeroed by nullify_buffer ($6162) at combat
; setup; in a 44-encounter trace it then read back ZERO (no non-nullify
; write hit it), so in ordinary combat the reader gets 0 = no modifier.
; Referenced by: calc_attack_damage, spell_stat_modifiers (ADDR_TABLE index $2E)
___table_97:
		DB $A0,0,0,0
		
; --- ___table_98 ---------------------------------------------
; @wip
; 4-byte fragment. Read via ADDR_TABLE index $57 by enemy_action_loop
; and enemy_turn_loop.
; Note: value-format unverified (see region banner).
; Referenced by: ADDR_TABLE index $57
___table_98:
		DB $78,$AA,$AA,$7A
		
; --- ___table_99 ---------------------------------------------
; @wip
; 4-byte fragment. Read via ADDR_TABLE index $01 by enemy_action_loop
; and spell_stat_modifiers.
; Note: value-format unverified (see region banner).
; Referenced by: ADDR_TABLE index $01
___table_99:
		DB $0A,$F8,$A0,$A0
		
; --- ___table_9A ---------------------------------------------
; @wip
; 4 bytes = a per-enemy-group attack bonus, indexed by the enemy group
; 0-3. calc_enemy_attack reads it at VAR_ACTIVE_ENEMY; spell_attack_bonus
; reads it at (target & $7F) and adds it via add_attack_bonus.
; CONFIRMED a runtime buffer: zeroed by nullify_buffer ($6162) at combat
; setup; in a 44-encounter trace it then read back ZERO (no non-nullify
; write hit it), so in ordinary combat the reader gets 0 = no modifier.
; Referenced by: calc_enemy_attack, spell_attack_bonus (ADDR_TABLE index $2C)
___table_9A:
		DB $F8,$AA,$AA,$AA
		
; --- ___table_9B ---------------------------------------------
; @wip
; 4-byte fragment. Read via ADDR_TABLE index $42 by apply_damage_dispatch,
; party_disbelieve, summon_ally, summon_creature and swap_group_field.
; Note: value-format unverified (see region banner).
; Referenced by: ADDR_TABLE index $42
___table_9B:
		DB $AA,0,$50,0

; --- ___table_9C ---------------------------------------------
; @wip
; Read via ADDR_TABLE index $2B as a 16-entry list: apply_damage_to_group
; (.scan_active) scans it for a 0 slot or one matching the current enemy
; group id; enemies_killed walks it (0 = end) to award XP/gold per hit
; group. So the ADDR_TABLE slot is a per-hit-group id list, with
; ___table_9D ($2A) the parallel kill-count array (as the readers treat it).
; CONFIRMED zeroed by nullify_buffer ($6162) at combat setup, so the static
; bytes below (which read as gfx fill) are just power-on junk. In a 44-
; encounter trace it then stayed ZERO (no non-nullify write hit it), so the
; readers get an all-zero list in basic combat - the write path that would
; populate it goes via hl' and was not seen here (see region banner).
; Referenced by: apply_damage_to_group, enemies_killed (ADDR_TABLE index $2B, reads)
___table_9C:
		DB $50,$50,$50,$50,$50
		DB 0,$0A,0,$0A,$0A,$0A,$0A,$AA,$78,$A0
		DB $AA
		
; --- ___table_9D ---------------------------------------------
; @wip
; Read via ADDR_TABLE index $2A as the kill-count array parallel to
; ___table_9C ($2B): apply_damage_to_group READS it (0 = skip) and
; enemies_killed READS it (0 = skip) to size the XP/gold award per group.
; CONFIRMED zeroed by nullify_buffer ($6162) at combat setup. NOTE the
; "increment" apply_damage_to_group does (`inc (hl)`) writes through the
; alternate hl', which the write-trace did NOT see land here - so whether
; this slot is the array that gets incremented, or just the read side of
; it, is unproven; over 44 encounters it stayed zero (see region banner).
; Referenced by: apply_damage_to_group, enemies_killed (ADDR_TABLE index $2A, reads)
___table_9D:
		DB $EA,$F8,$EA,$AA,$AA,0,$50,$50,$50
		DB $50,$50,$50,$50,0,0,0
		
; --- ___table_9E ---------------------------------------------
; @wip
; 7-byte fragment. Read via ADDR_TABLE index $3A by hero_cast_action
; and option_is_found.
; Note: value-format unverified (see region banner).
; Referenced by: ADDR_TABLE index $3A
___table_9E:
		DB $AA,$FA,$AA,$AA,$AA,0,0
		
; --- ___table_9F ---------------------------------------------
; @wip
; 7-byte fragment. Read via ADDR_TABLE index $3C by
; dispatch_hero_action and option_cancel.
; Note: value-format unverified (see region banner).
; Referenced by: ADDR_TABLE index $3C
___table_9F:
		DB 0,$F8,$AA,$AA,$AA,$AA
		DB 0
		
; --- ___table_9G ---------------------------------------------
; @wip
; 7-byte fragment. Read via ADDR_TABLE index $38 by hero_turn_body.
; Note: value-format unverified (see region banner).
; Referenced by: ADDR_TABLE index $38
___table_9G:
		DB 0,0,$78,$AA,$AA,$AA,$78
		
; --- ___table_9H ---------------------------------------------
; @wip
; Large fragment (~150 bytes) that embeds the combat/roster UI text:
; "Character Name   AC Hits Cond SpPt Cl", then $FF-delimited status
; lines "FOUND BARD", "SEARCHING FOR BARD", "LOADING " — interleaved
; with pixel-nibble graphics. Reached via ADDR_TABLE index $40, read
; by check_playtune and pick_hero_scan (the label points at the start
; of this UI/graphics chunk).
; Note: exact split of text vs graphics not yet reverse-engineered.
; Referenced by: ADDR_TABLE index $40
___table_9H:
		DB 0,0
		DB 0,$F8,$AA,$AA,$F8,$A0,$A0,0,0,$DA
		DB $AA,$AA,$DA,$0A,$0A,0,0,$78,$AA,$A0
		DB $A0,$A0,0,0,0,$7A,$A0,$78,$0A,$F8
		DB 0,$50,$50,$FA,$50,$50,$50,$50,0,0
		DB 0,$AA,$AA,$AA,$AA,$D8,0,0,0,$AA
		DB $AA,$AA,$78,$50,0,0,0,$AA,$AA,$AA
		DB $FA,$AA,0,0,0,$AA,$AA,$78,$AA,$AA
		DB 0,0,0,$AA,$AA,$AA,$7A,$0A,$F8,0
		DB 0,$FA,$0A,$78,$A0,$FA,0,$C0,$C0,$C0
		DB $FF,0,0,0,0,$18,$5A,$5A,$42,$DE
		DB $63,$18,0,3,3,3,$FF,0,0,0
		DB 0,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$55
		DB $55,$55,$27,$AF,$AF,$AF,$FF,$3C,$3C,$3C
		DB $3C,$14,$3D,$FF,$FF,$F1,$F0,$F1,$F1,$50
		DB $3C,$FF,$FF,$1F,$7F,$FF,$CF,$4F,$3F,$FF
		DB $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$E8
		DB $E8,$E8,$E8,$E8,$E8,$E8,$A8,0,0,$FF
		DB $FF,$C0,$C0,$C0,$C0,$E5,$CD,$95,$FE,$3A
		DB $16,$FF,$3C,$32,$16,$FF,$E1,$C9,$F5,$3A
		DB $15,$FF,$4F,$E6,$18,$C6,$40,$67,$79,$0F
		DB $0F,$0F,$E6,$E0,$6F,$3A,$16,$FF,$4F,6
		DB 5,$81,$10,$FD,$5F,$CB,$3B,$CB,$3B,$CB
		DB $3B,$16,0,$19,$EB,$E6,7,$4F,$F1,$D6
		DB $1F,$21,$F8,$3C,$D5,$11,8,0,$19,$3D
		DB $20,$FC,$D1,$E5,$C5,$21,$FF,$81,$41,4
		DB $CB,$2C,$CB,$1D,$10,$FA,$ED,$6A,$ED,$6A
		DB $C1,$E3,$3E,8,8,$E3,$EB,$7A,$A6,$77
		DB $7B,$23,$A6,$77,$2B,$EB,$E3,$7E,$23,$E6
		DB $7E,$CB,$27,$E5,$67,$2E,0,$C5,$41,$E6
		DB 5,$6F,5,$DA,$FF,$FA,$C1,$29,$EB,$7A
		DB $B6,$77,$23,$7B,$B6,$77,$2B,$24,$EB,$E1
		DB 8,$3D,$20,$CE,$D1,$C9,$18,0,$43,$68
		DB $61,$72,$61,$63,$74,$65,$72,$20,$4E,$61
		DB $6D,$65,$20,$20,$20,$41,$43,$20,$48,$69
		DB $74,$73,$20,$43,$6F,$6E,$64,$20,$53,$70
		DB $50,$74,$20,$43,$6C,$FF,$60,$46,$4F,$55
		DB $4E,$44,$20,$42,$41,$52,$44,$FF,$51,$A3
		DB $40,$53,$45,$41,$52,$43,$48,$49,$4E,$47
		DB $20,$46,$4F,$52,$20,$42,$41,$52,$44,$FF
		DB $80,$4C,$4F,$41,$44,$49,$4E,$47,$20,$FF
		DB $5E,$23,$56,$23,$7E
		
; --- ___table_9I ---------------------------------------------
; @wip
; 7-byte fragment. Read via ADDR_TABLE index $56 by battle_hero_loop,
; commit_action, dispatch_hero_action, finish_summon, option_is_found
; and spell_heal_and_cure (a much-used per-action value).
; Runtime trace (m8xxx, tools/m8xxx/combat_trace.html): read with
; sub-index 1..4 during combat rounds (the per-hero action loop) ->
; likely indexed by hero/action slot; exact value meaning still unverified.
; Note: value-format unverified (see region banner).
; Referenced by: ADDR_TABLE index $56
___table_9I:
		DB $3C,$C8,$3D,$E5,$6F,$26,0
		
; --- ___table_9J ---------------------------------------------
; @wip
; 4 bytes ($29,$29,$29,1) — end of the region ($FF78). Read via
; ADDR_TABLE index $3B by hero_cast_action, option_is_found and
; teleport_to_level.
; Note: value-format unverified (see region banner).
; Referenced by: ADDR_TABLE index $3B
___table_9J:
		DB $29,$29,$29,1
