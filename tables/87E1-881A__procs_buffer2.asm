; --- PROCS_2 --------------------------------------------------
; @done
; DW dispatch table (28 entries, 2 bytes each) of spell-effect handler
; routines. casts_a_spell maps the spell letter through table $26 to an
; effect index B, then reads this table one byte at a time
; (GET_B_FROM_TABLE $25 for low, inc B, again for high) to build the
; handler address and invoke it via a self-modified call.
; Referenced by: ADDR_TABLE index $25 - casts_a_spell (spell resolution)
PROCS_2:
		DW light_the_light
		DW resolve_spell_effect
		DW mod_stat_21
		DW process_dungeon_step
		DW mod_stat_22
		DW compass_setup
		DW spell_attack_bonus
		DW heal_or_cure
		DW spell_stat_modifiers
		DW carpet_setup
		DW breath_attack_run
		DW spell_summon_monster
		DW spell_state_0
		DW proc_teleport
		DW mod_stat_5D
		DW eye_setup
		DW apply_anti_magic
		DW spell_flee_effect
		DW spell_breath_attack
		DW compass_speed_lookup
		DW show_location_info
		DW shield_setup
		DW spell_roll_damage
		DW clamp_defense_bonus
		DW spell_reveal_secret
		DW check_spell_valid
		DW summon_creature
		DW spell_state_1
		DW spell_state_4
