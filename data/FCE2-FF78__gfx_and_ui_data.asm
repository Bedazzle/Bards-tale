; === FCE2-FF78 region ========================================
; A mixed block of screen-graphics fragments and UI text into which
; many ADDR_TABLE targets fall. Bytes read as 2-bit pixel nibbles
; ($AA,$50,$78,$FA,$FF) plus embedded ASCII strings (see COMBAT_UI_TEXT:
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
; (The populate side, once "unproven", is now carved - see POPULATE PATH
; FOUND + COMBAT RECORD MODEL below.)
; The static bytes below are therefore just power-on junk (they happen to
; read as gfx fill); the live content is runtime combat state. Roles from
; the consumers:
;   $56 -> per-hero queued combat action (dispatch_hero_action dispatches
;          on it: 1=melee,3=cast,4=cast/use,6=item,8=confused);
;   $40 -> per-hero status/hide flag (select_random_hero skips nonzero);
;   $2A/$2B -> hit-group id list + kill-count array (enemies_killed);
;   $2C/$2D/$2E -> per-enemy-group attack / AC / damage modifiers.
; (These slots have since been NAMED after their roles - GROUP_AC_MOD,
; HERO_ACTION_CODE, HIT_GROUP_LIST, etc. - and marked @done as their
; writers+readers were carved; see the per-slot headers below.)
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
; CONSUMER's interpretation of what a non-zero value WOULD mean.
;
; POPULATE PATH FOUND (2026-07-12, static writer hunt - SUPERSEDES the
; "not observed" note above): the writers reference these labels DIRECTLY;
; they just weren't exercised by the earlier city-combat trace. Identified:
;   clean_ally_memory   -> zeroes ALLY_STATE/FD7A_ANCHOR/ALLY_DATA (ally
;                          bookkeeping) on ally release;
;   calc_in_FD7A        -> FD7A_ANCHOR+2 ($FD7A) is the base of a 100-byte-
;                          per-enemy-group combat record table;
;   calc_combat_initiative -> writes per-combatant initiative/speed into
;                          COMBAT_INITIATIVE ($FDD1/$FDD6);
;   battle_play_tune / commit_action -> write per-hero action codes in
;                          HERO_ACTION_CODE ($56);
;   zero_buffers        -> clears the block from HERO_CAST_STATE+2 ($FF77) down.
; So the region is genuine combat working RAM (per-group records + per-hero
; state + ally flags), zeroed at setup and filled by the routines above -
; the per-slot roles below are now backed by an identified writer + reader.
;
; COMBAT RECORD MODEL (2026-07-12, carved from generate_encounter /
; enemy_group_advance / apply_damage_dispatch / calc_in_FD7A):
; The enemy side of a fight is held in THREE parallel per-group structures,
; all indexed by group id 0-3:
;   * $FB98 (ADDR_TABLE $36, "COMBAT_ACTIVE_FLAG") - per-group MEMBER COUNT
;     (GET_B_FROM_TABLE $36 => how many creatures are left in group b);
;   * FB7D table ($FB7D, via CALC_IN_FB7D = proc $32) - 100 bytes per group,
;     one byte per member = the member's HP (damage is subtracted here);
;   * FD7A table ($FD7A, via CALC_IN_FD7A = proc $57, the macro misnamed
;     CALC_SPELL_FX) - 100 bytes per group, one byte per member = member
;     STATUS (bit 0 = alive; apply_damage_dispatch scans it for a live
;     member, res-0's it on death, then compacts the list).
; calc_in_* return hl = base + 100*(group+1), so group 0's record starts at
; base+$64: FD7A records live at $FDDE/$FE42/$FEA6/$FF0A. That means the
; $FD7A-$FDDD "record -1" area is a HEADER holding the small per-group
; summary slots below (GROUP_AC_MOD/GROUP_ATK_MOD/HIT_GROUP_LIST/...), while
; $FDDE-$FF0D is TIME-MULTIPLEXED: it
; holds the group member records DURING a fight and the combat-roster UI
; text (in COMBAT_UI_TEXT) otherwise - which is why the "graphics/UI" bytes
; and "combat scratch" occupy the same addresses.
;
; --- (leading graphics fragment @ $FCE2) --------------------
; @done
; ~26 bytes of 2-bit pixel-nibble graphics ($AA/$FA/$72/$F8/$50...) at the
; very start of the region, contiguous with byte_FCFC below - part of the
; combat-screen border/decoration artwork. Not an ADDR_TABLE target (the
; first slot, ALLY_STATE $45, is at $FD71); pure graphics data, kept as an
; incbin-style DB block. (The specific artwork isn't decoded, same as
; byte_FCFC - a graphics fragment, not a table.)
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

; --- ALLY_STATE ---------------------------------------------
; @done
; Ally bookkeeping byte (combat scratch). clean_ally_memory zeroes it
; (`ld (ALLY_STATE),a`) when a summoned ally is released; post_combat_cleanup
; and recalc_party_ac read it (index $45) as part of rebuilding the party/
; ally AC + slot lists after combat. Power-on bytes below are junk.
; Referenced by: written clean_ally_memory; read post_combat_cleanup,
;               recalc_party_ac (ADDR_TABLE index $45)
ALLY_STATE:	
		DB 0
		DB $78
		DB $AA
		DB $A0
		DB $AA
		DB $78
		DB 0

; --- FD7A_ANCHOR ---------------------------------------------
; @done
; Ally bookkeeping byte + FD7A-table anchor. clean_ally_memory zeroes it
; (`ld (FD7A_ANCHOR),a`) on ally release; post_combat_cleanup and
; spell_attack_bonus read it (index $30). Its +2 offset ($FD7A) is the
; BASE of the 100-byte-per-enemy-group combat record table (calc_in_FD7A
; does `ld hl,FD7A_ANCHOR+2` then strides 100 bytes per group).
; Referenced by: written clean_ally_memory; read post_combat_cleanup,
;               spell_attack_bonus; +2 = FD7A table (ADDR_TABLE index $30)
FD7A_ANCHOR:
		DB $0A
		DB $0A
		DB $DA
		DB $AA
		DB $AA
		DB $AA
		DB $DA

; --- ALLY_DATA ------------------------------------------------
; @done
; Ally-present flag / bookkeeping byte for the single summoned ally.
; clean_ally_memory zeroes it (`ld (ALLY_DATA),a`, alongside ALLY_STATE/FD7A_ANCHOR
; and VAR_ALLY_COUNTER) so no ally is considered present; the summon path
; and post_combat_cleanup .rebuild_lists reference slot $2F when tracking
; the ally. Power-on bytes below are junk.
; Referenced by: written clean_ally_memory; ADDR_TABLE index $2F (ally slot)
ALLY_DATA:
		DB 0,0,0,$D8,$AA,$FA,$A0

; --- GROUP_AC_MOD ---------------------------------------------
; @done
; Per-enemy-group AC modifier: a 4-byte array (one byte per group 0-3) at
; FD7A+$0C in the combat header (see COMBAT RECORD MODEL). calc_enemy_attack
; reads it at VAR_ACTIVE_ENEMY and folds it into the to-hit/AC calc;
; spell_ac_modifier reads it at (target & $7F). Zeroed at combat setup, so
; it defaults to 0 (= no AC modifier) unless a per-group AC effect sets it.
; Referenced by: calc_enemy_attack, spell_ac_modifier (ADDR_TABLE index $2D)
GROUP_AC_MOD:
		DB $7A,0,$78,$AA
		
; --- GROUP_AC_MOD2 ---------------------------------------------
; @done
; Second per-enemy-group AC field (FD7A+$10 in the combat header),
; companion to GROUP_AC_MOD ($2D). spell_ac_modifier applies an AC delta to
; BOTH $2D and $55 (A_PLUS_C_TO_HL on each) for a party target;
; calc_ac_worker and process_bard_song (bard AC songs) also read it.
; A 4-byte array (one per group 0-3), zeroed at combat setup, default 0.
; Referenced by: calc_ac_worker, process_bard_song, spell_ac_modifier (index $55)
GROUP_AC_MOD2:
		DB $A0,$F0,$A0,$A0

; --- GROUP_DMG_MOD ---------------------------------------------
; @done
; Per-enemy-group attack/damage bonus: a 4-byte array (one byte per group
; 0-3) at FD7A+$14 in the combat header. calc_attack_damage folds it into
; the damage roll; the spell_stat_modifiers entries (mod_stat_22 buff /
; mod_stat_5D debuff) read it at (target & $7F) to add/subtract a bonus.
; Zeroed at combat setup, so it defaults to 0 (= no bonus) unless a
; per-group attack effect sets it.
; Referenced by: calc_attack_damage, spell_stat_modifiers (ADDR_TABLE index $2E)
GROUP_DMG_MOD:
		DB $A0,0,0,0
		
; --- GROUP_TURN_SKIP ---------------------------------------------
; @done
; Per-enemy-group TURN-SKIP flag (combat header, FD7A+$18), a 4-byte array
; (one per group 0-3). combat_foes' enemy turn loop reads it
; (GET_B_FROM_TABLE $57) after the member count and, if NONZERO, skips that
; group's turn (jr nz,next_enemy) - i.e. a "group fled / can't act this
; round" marker. enemy_action_loop resets it (paired with ___table_99 $01).
; Zeroed at setup (default = group acts).
; Referenced by: combat_foes enemy turn loop, enemy_action_loop (index $57)
GROUP_TURN_SKIP:
		DB $78,$AA,$AA,$7A
		
; --- ___table_99 ---------------------------------------------
; @wip
; Per-enemy-group combat flag at FD7A+$1C in the combat header (4 bytes,
; one per group 0-3), the COMPANION of the GROUP_TURN_SKIP ($57) turn-skip flag
; - enemy_action_loop resets the two together each round. spell_stat_modifiers
; also reads it at (target & $7F) and increments a paired hl' counter.
; Zeroed at setup. Kept @wip: the precise meaning of the value (vs the $57
; turn-skip flag it pairs with) is not pinned down.
; Referenced by: ADDR_TABLE index $01 ONLY (no reader found statically; a per-group
; combat buffer likely reached via a COMPUTED group index in the combat loop)
___table_99:
		DB $0A,$F8,$A0,$A0
		
; --- GROUP_ATK_MOD ---------------------------------------------
; @done
; Per-enemy-group attack bonus: a 4-byte array (one byte per group 0-3) at
; FD7A+$20 in the combat header. calc_enemy_attack reads it at
; VAR_ACTIVE_ENEMY; spell_attack_bonus reads it at (target & $7F) and adds
; it via add_attack_bonus. Zeroed at combat setup, so it defaults to 0
; (= no bonus) unless a per-group attack effect sets it.
; Referenced by: calc_enemy_attack, spell_attack_bonus (ADDR_TABLE index $2C)
GROUP_ATK_MOD:
		DB $F8,$AA,$AA,$AA
		
; --- GROUP_ILLUSION_FLAG ---------------------------------------------
; @done
; Per-enemy-group ILLUSION / disbelieve flag (combat header, FD7A+$24), a
; 4-byte array (one per group 0-3). party_disbelieve reads it
; (GET_C_FROM_TABLE $42) and skips a group whose entry is 0 (`jr z` = not an
; illusion) - so nonzero marks an illusionary group the party may see
; through. Also touched by apply_damage_dispatch (GET_C_FROM_LIST $42),
; summon_ally/summon_creature (an ally uses group slot $42) and
; swap_group_field when groups are compacted. Zeroed at setup.
; Referenced by: party_disbelieve, apply_damage_dispatch, summon_*,
;               swap_group_field (ADDR_TABLE index $42)
GROUP_ILLUSION_FLAG:
		DB $AA,0,$50,0

; --- HIT_GROUP_LIST ---------------------------------------------
; @done
; Hit-group id list (FD7A+$28 in the combat header). apply_damage_to_group
; (.scan_active) scans it as a 16-entry list for a 0 slot or one matching
; the current enemy group id (appending the group when it first takes
; damage); enemies_killed then walks it (0 = end) to award XP/gold per hit
; group, paired with HIT_GROUP_KILLS ($2A) the kill-count array. Zeroed by
; nullify_buffer at combat setup (empty list default).
; (Honest caveat: apply_damage's .mark_active `ld (hl),a`/`inc (hl)` writes
; go via the alternate hl'; the write-trace did not confirm they land in
; THIS header slot vs the FD7A member record - but the read role is clear.)
; Referenced by: apply_damage_to_group, enemies_killed (ADDR_TABLE index $2B)
HIT_GROUP_LIST:
		DB $50,$50,$50,$50,$50
		DB 0,$0A,0,$0A,$0A,$0A,$0A,$AA,$78,$A0
		DB $AA
		
; --- HIT_GROUP_KILLS ---------------------------------------------
; @done
; Kill-count array (FD7A+$38 in the combat header), parallel to the
; HIT_GROUP_LIST ($2B) hit-group id list: apply_damage_to_group increments the
; entry when a group loses a member; enemies_killed reads it (0 = skip) to
; size the XP/gold award per group. Zeroed by nullify_buffer at combat
; setup (all-zero default).
; (Honest caveat: the `inc (hl)` write is via the alternate hl' and the
; write-trace did not confirm it lands in THIS header slot; read role clear.)
; Referenced by: apply_damage_to_group, enemies_killed (ADDR_TABLE index $2A)
HIT_GROUP_KILLS:
		DB $EA,$F8,$EA,$AA,$AA,0,$50,$50,$50
		DB $50,$50,$50,$50,0,0,0
		
; --- HERO_QUEUED_ITEM ---------------------------------------------
; @done
; Per-hero queued-action ITEM parameter (combat header, FD7A+$48). Part of
; the per-hero action record {code=HERO_ACTION_CODE $56, item=$3A, target=$3B
; (HERO_CAST_STATE), spell=$3C (HERO_QUEUED_SPELL)}: after dispatch_hero_action reads
; the action code and finds "use item", it reads $3A (GET_B_FROM_TABLE $3A)
; and passes it to use_and_break_item. commit_action / option_is_found
; write it (GET_*_FROM_LIST $3A) when the hero commits the action. Zeroed
; at setup; one byte per hero slot.
; Referenced by: written commit_action; read dispatch_hero_action
;               (ADDR_TABLE index $3A)
; Referenced by: ADDR_TABLE index $3A
HERO_QUEUED_ITEM:
		DB $AA,$FA,$AA,$AA,$AA,0,0
		
; --- HERO_QUEUED_SPELL ---------------------------------------------
; @done
; Per-hero queued-action SPELL parameter (combat header, FD7A+$4F). Part of
; the per-hero action record (see HERO_QUEUED_ITEM): for action "cast",
; dispatch_hero_action reads $3C (GET_B_FROM_TABLE $3C) and stores it into
; VAR_CURRENT_SPELL before resolving the spell; commit_action /
; option_is_found write it (GET_*_FROM_LIST $3C) at commit time. Zeroed at
; setup; one byte per hero slot.
; Referenced by: written commit_action; read dispatch_hero_action
;               (ADDR_TABLE index $3C)
; Referenced by: ADDR_TABLE index $3C
HERO_QUEUED_SPELL:
		DB 0,$F8,$AA,$AA,$AA,$AA
		DB 0
		
; --- COMBAT_INITIATIVE ---------------------------------------------
; @done
; Per-combatant INITIATIVE / speed buffer (combat scratch). Written by
; calc_combat_initiative each round: it fills the per-hero/enemy-group
; speed values here (the FDD1/FDD6 initiative slots, COMBAT_INITIATIVE+$1/+$6),
; or zeroes COMBAT_INITIATIVE+$6 (7 bytes) on a surprise round. hero_turn_body
; reads it (GET_B_FROM_TABLE $38) to drive turn order. Power-on bytes junk.
; Referenced by: written calc_combat_initiative; read hero_turn_body
;               (ADDR_TABLE index $38)
COMBAT_INITIATIVE:
		DB 0,0,$78,$AA,$AA,$AA,$78
		
; --- COMBAT_UI_TEXT ---------------------------------------------
; @done
; Dual-purpose block (~150 bytes) at $FDD7. Its FIRST 7 bytes are a
; per-hero combat scratch field: nullify_FDDD zeroes them at combat start
; (called by fight_or_run / enemies_killed) and select_random_hero reads
; them via ADDR_TABLE index $40 (a per-hero status/skip flag). The REST is
; the combat-screen UI text with RST-10h print codes: the roster column
; header "Character Name   AC Hits Cond SpPt Cl", then $FF-delimited status
; lines "FOUND BARD" / "SEARCHING FOR BARD" / "LOADING ", read by
; check_playtune and pick_hero_scan. (The $40 slot's +1 base lands in the
; scratch bytes; the text follows.)
; Referenced by: zeroed nullify_FDDD; read select_random_hero ($40),
;               check_playtune, pick_hero_scan (ADDR_TABLE index $40)
COMBAT_UI_TEXT:
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
		
; --- HERO_ACTION_CODE ---------------------------------------------
; @done
; Per-hero queued combat-action buffer, indexed by hero slot. WRITTEN by
; battle_play_tune / commit_action (battle_play_tune walks 7 entries from
; HERO_ACTION_CODE+6 and rewrites action code 7 -> 1 when committing "party
; fight"). dispatch_hero_action READS a hero's slot (GET_B_FROM_TABLE $56)
; and dispatches on the code: 1=melee, 3=cast, 4=cast/use, 6=item,
; 8=confused; also read by battle_hero_loop / option_is_found / finish_summon
; / spell_heal_and_cure. The runtime trace saw sub-index 1..4 (the per-hero
; loop), consistent with one action byte per party slot.
; Referenced by: written battle_play_tune/commit_action; read
;               dispatch_hero_action + others (ADDR_TABLE index $56)
; Referenced by: ADDR_TABLE index $56
HERO_ACTION_CODE:
		DB $3C,$C8,$3D,$E5,$6F,$26,0
		
; --- HERO_CAST_STATE ---------------------------------------------
; @done
; Combat working-buffer anchor at the top of the region. zero_buffers
; clears $96*3 = 450 bytes downward from HERO_CAST_STATE+2 ($FF77) at combat
; setup (the main "clear combat scratch" sweep). The slot itself is read
; via ADDR_TABLE index $3B by hero_cast_action / option_is_found (per-hero
; cast bookkeeping) and by teleport_to_level (GET_IY_A_FROM_TABLE $3B,$58
; = the target-level index for the teleport). Power-on bytes below junk.
; Referenced by: cleared by zero_buffers; read hero_cast_action,
;               option_is_found, teleport_to_level (ADDR_TABLE index $3B)
; Referenced by: ADDR_TABLE index $3B
HERO_CAST_STATE:
		DB $29,$29,$29,1
