; -------------------------------------
		include "constants.asm"
		include "constants_guild.asm"
		include "code/macroses.asm"

binary_start:
; -------------------------------------
		jp	INIT_GAME
; -------------------------------------

		include "code/5B03-5B3D__game_cycle.asm"
		include "code/5B3E-5B7C__press_hero_number.asm"
		include "code/5B7D-5B8A__print_spaces_eol.asm"
		include "code/5B8B-5BA7__print_hero_attr.asm"
		include "code/5BA8-5BE0__get_pressed_key.asm"
		include "code/5BE1-5C16__print_number.asm"
		include "code/5C17-5C50__binary_to_decimal.asm"

; -------------------------------------
		DW dynamic_vector
dynamic_vector:
		DW run_dynamic

		include "data/5C55-5C5C__daypart_roll_mask.asm"
		include "data/5C5D-5C64__daypart_roll_add.asm"
; -------------------------------------

JP_INTERRUPT:
		jp	interrupt

; -------------------------------------
PARTY_FILE:
		DB 0,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
		DB $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
		DB $FF,$FF,$FF,0,0,0,0

		include "data/5C83-5FAA__heroes.asm"
		include "data/5FAB-6022__game_variables.asm"

		include "code/6023-6052__INIT_GAME.asm"
		include "code/6053-605D__wait_key_down.asm"
		include "code/605E-60A4__process_game_turn.asm"
		include "code/60A5-6154__process_daynight.asm"
		include "code/6155-6166__nullify_buffer.asm"
		include "code/6167-6175__print_letter_pair.asm"

		include "tables/6176-61D7__statuses.asm"

		include "code/61D8-61F4__find_hero.asm"
		include "code/61F5-6204__check_hero_status.asm"
		include "code/6205-621A__clear_info_panl.asm"
		include "code/621B-6232__prnt_space_line.asm"
		include "code/6233-6298__enter_text.asm"
		include "code/6299-62A9__print_yesno_wait.asm"
		include "code/62AA-62E6__print_loc_name.asm"
		include "code/62E7-62F6__show_name_pic_AB.asm"
		include "code/62F7-645F__load_save_file.asm"

		include "data/6460-649B__fixed_locations.asm"

		include "code/649C-64BF__push_pop_regs.asm"
		include "code/64C0-64C9__get_rnd_by_param.asm"
		include "code/64CA-64DB__check_item_effect.asm"
		include "code/64DC-64F2__exec_for_heroes.asm"
		include "code/64F3-6569__city_colors.asm"
		include "code/656A-65FE__generate_encounter.asm"
		include "code/65FF-6615__zero_buffers.asm"
		include "code/6616-6629__calculate_addr.asm"
		include "code/662A-6699__encounter.asm"
		include "code/669A-6705__enemy_group_advance.asm"
		include "code/6706-6712__swap_byte_buffer.asm"
		include "code/6713-6733__show_some_pictext.asm"
		include "code/6734-6745__clear_txt_buffer.asm"
		include "code/6746-680C__calc_combat_initiative.asm"
		include "code/680D-6857__select_random_hero.asm"
		include "code/6858-68AC__fight_or_run.asm"
		include "code/68AD-6914__battle_options.asm"
		include "code/6915-6976__option_is_found.asm"
		include "code/6977-69B7__handle_battle_actions.asm"
		include "code/69B8-6A02__battle_play_tune.asm"
		include "code/6A03-6A26__select_spell_target.asm"
		include "code/6A27-6A48__find_alive_hero.asm"
		include "code/6A49-6A65__get_rnd_numbers.asm"
		include "code/6A66-6AC5__combat_flee_check.asm"
		include "code/6AC6-6ACB__divide_A_by_8.asm"
		include "code/6ACC-6B23__calc_defense_rating.asm"
		include "code/6B24-6B64__print_hero_items.asm"
		include "code/6B65-6BC1__process_spell.asm"
		include "code/6BC2-6C82__select_combat_target.asm"
		include "code/6C83-6CAA__print_memb_num.asm"

; -------------------------------------


; --- set_target_select -----------------------------------------
; @done
; Store the combat target-select code (a + $42) into VAR_TARGET_SELECT.
; In:  a = target index
set_target_select:
		add	a,$42 ; 'B'
		ld	(GAME_VARIABLES + VAR_TARGET_SELECT),a

		ret

; ======= S U B	R O U T	I N E =========


; --- clear_target_select ---------------------------------------
; @done
; Zero the 3-byte VAR_TARGET_SELECT buffer; preserves af.
clear_target_select:
		push	af
		ld	hl,GAME_VARIABLES + VAR_TARGET_SELECT
		ld	b,3
		call	nullify_buffer
		pop	af

		ret

; -------------------------------------

		include "code/6CBC-6CCE__count_heroes.asm"
		include "code/6CCF-6CD6__print_group.asm"
		include "code/6CD7-6D04__check_equipped.asm"
		include "code/6D05-6D2B__find_special_weapon.asm"

; -------------------------------------

; --- check_three_heroes ----------------------------------------
; @done
; CHECK_THREE_HEROES dispatch: test party slots 0-2 via table $36.
; Out: NZ if any of the three fails; CF set if all three pass
check_three_heroes:				; CHECK_THREE_HEROES
		ld	b,3

.loop:
		GET_B_FROM_TABLE	$36

		ret	nz

		dec	b
		jp	p,.loop

		scf

		ret

; ======= S U B	R O U T	I N E =========


; --- print_and_pad_row -----------------------------------------
; @done
; Home the info cursor (set_cursor_home) then pad the row with $0E spaces.
print_and_pad_row:
		call	set_cursor_home
		ld	a,$0E
		call	print_spaces_eol

; --- set_cursor_home -------------------------------------------
; @done
; Set the info-panel cursor to row/col $010E.
set_cursor_home:
		ld	hl,$010E
		ld	(GAME_VARIABLES + VAR_CURSOR_ROW),hl

		ret

; -------------------------------------

		include "code/6D47-70A9__combat_foes.asm"
		include "code/70AA-70BB__attack_and_result.asm"
		include "code/70BC-70D6__show_damage.asm"
		include "code/70D7-713C__new_order.asm"

; ======= S U B	R O U T	I N E =========


; --- show_monster_magic ----------------------------------------
; @done
; Look up and run the monsters-magic handler (table id $72) via lookup_addr_by_A.
show_monster_magic:
		PUSH_REGS

		ld	a,$72		; monsters magic

		jp	lookup_addr_by_A
; -------------------------------------

		include "code/7144-719A__lookup_addr_table.asm"
		include "code/719B-71AF__print_combat_actor.asm"
		include "code/71B0-7226__print_hero_stats.asm"
		include "code/7227-722C__print_and_wait.asm"
		include "code/722D-72DC__trade_gold.asm"
		include "code/72DD-72F6__drop_item.asm"
		include "code/72F7-7304__all_full.asm"
		include "code/7305-7362__equip_item.asm"
		include "code/7363-737E__enter_number.asm"
		include "code/737F-73A5__print_magic_attrs.asm"
		include "code/73A6-73E7__process_action_key.asm"

		include "tables/73E8-7405__procs_actions.asm"

; ======= S U B	R O U T	I N E =========


; --- run_default_action ----------------------------------------
; @done
; Enter the action dispatcher (run_action_by_e) with the default a=6, c=4.
run_default_action:
		ld	a,6
		ld	c,4

		jr	run_action_by_e

; -------------------------------------

		include "code/740C-742D__cast_spell.asm"
		include "code/742E-7433__print_who_will.asm"
		include "code/7434-74BF__play_song.asm"
		include "code/74C0-7533__use_item.asm"

; -------------------------------------

; --- if_FB98_is_zero -------------------------------------------
; @done
; Set Z according to whether COMBAT_ACTIVE_FLAG is zero.
if_FB98_is_zero:
		ld	a,(COMBAT_ACTIVE_FLAG)
		or	a

		ret
; -------------------------------------

		include "code/7539-758F__who_cast_spell.asm"
		include "code/7590-75A4__check_spell_cost.asm"
		include "code/75A5-75BE__use_and_break_item.asm"
		include "code/75BF-7624__calc_armor_class.asm"
		include "code/7625-7638__recalc_party_ac.asm"
		include "code/7639-7663__add_item_to_hero.asm"
		include "code/7664-768F__print_hero_attrib.asm"
		include "code/7690-76B8__shoppe_pool_gold.asm"
		include "code/76B9-76EC__calc_xp_for_level.asm"
		include "code/76ED-771B__increas_12_digits.asm"
		include "code/771C-773B__add_to_bcd_number.asm"
		include "code/773C-7757__copy_hero_money.asm"
		include "code/7758-7765__is_roster_full.asm"
		include "code/7766-7779__check_heroes_alive.asm"

; -------------------------------------

; --- get_attr_param --------------------------------------------
; @done
; Fetch a hero attribute (via get_attr_by_E) into the 12-digit work buffer
; at LEVEL_STOP+$A for BCD arithmetic.
; In:  e = attribute id, ix = hero
get_attr_param:
		PUSH_REGS

		call	get_attr_by_E
		ex	de,hl
		ld	hl,LEVEL_STOP+$A

		jr	dec_digits_at_hl

; ======= S U B	R O U T	I N E =========


; --- get_attr_by_E ---------------------------------------------
; @done
; Fetch hero attribute (e + $0B) via get_attr_by_A.
get_attr_by_E:
		ld	a,e
		add	a,$0B

		jp	get_attr_by_A

; -------------------------------------

		include "code/778B-77AF__decreas_12_digits.asm"
		include "code/77B0-77D7__store_bcd_and_compare.asm"
		include "code/77B8-77FF__unpack_hero_attrs.asm"
		include "code/7800-7827__pack_hero_attrs.asm"
		include "code/7828-78A7__summon_creature.asm"
		include "code/78A8-78CB__apply_anti_magic.asm"
		include "code/78CC-78D9__process_dungeon_step.asm"
		include "code/78DA-7905__process_poison.asm"
		include "code/7906-794C__party_disbelieve.asm"
		include "code/794D-7966__spend_spell_points.asm"
		include "code/7967-7A31__post_combat_cleanup.asm"
		include "code/7A32-7A49__clean_ally_memory.asm"
		include "code/7A4A-7A66__clean_hero_memory.asm"
		include "code/7A67-7A9D__process_special_event.asm"
		include "code/7A9E-7AB7__find_equipped_by_type.asm"
		include "code/7AB8-7BEC__calc_attack_damage.asm"
		include "code/7BED-7BF3__divide_A_by_16.asm"
		include "code/7BF4-7C4D__calc_enemy_attack.asm"
		include "code/7C4E-7CD2__apply_damage_to_group.asm"
		include "code/7CD3-7DB3__apply_damage_to_hero.asm"

		include "data/7DB4-7DB7__swap_stat_template.asm"

; ======= S U B	R O U T	I N E =========

		include "code/7DB8-7DF8__regenerate_hp_sp.asm"
		include "code/7DF9-7E37__regen_equipped_effects.asm"
		include "code/7E38-7F78__enemies_killed.asm"
		include "code/7F79-7FB2__award_experience.asm"
		include "code/7FB3-7FF1__enemy_joins_party.asm"
		include "code/7FF2-8064__process_bard_song.asm"
		include "code/8065-806C__dummy_pause.asm"

; -------------------------------------

; --- change_combat_speed ---------------------------------------
; @done
; CHANGE_COMBAT_SPEED dispatch: bump the combat-speed setting (table $58
; index $27) and fall into the speed-adjust loop.
change_combat_speed:						; CHANGE_COMBAT_SPEED
		PUSH_REGS

		ld	e,1

		GET_IY_A_FROM_TABLE	$58,$27

		jr	loop_speed
; -------------------------------------

		include "code/8077-80BB__change_speed.asm"
		include "code/80BC-80D3__set_pause.asm"
		include "code/80D4-80FA__oh_dear_game_over.asm"
		include "code/80FB-810D__choose_hero.asm"
		include "code/810E-816E__spell_casting.asm"
		include "code/816E-819A__light_the_light.asm"
		include "code/819B-81D4__check_spell_valid.asm"
		include "code/81D5-82BD__resolve_spell_effect.asm"
		include "code/82BE-82D1__tick_spell_duration.asm"

; ======= S U B	R O U T	I N E =========


; --- clear_spell_active ----------------------------------------
; @done
; Clear VAR_SPELL_ACTIVE (no spell currently being cast).
clear_spell_active:
		ld	(iy+VAR_SPELL_ACTIVE),0

		ret

; -------------------------------------

		include "code/82D7-82FB__start_spell_or_song.asm"

		include "data/82FC-8313__spell_song_tables.asm"

		include "code/8314-8412__spell_breath_attack.asm"
		include "code/8413-8496__spell_stat_modifiers.asm"
		include "code/8497-8517__spell_heal_and_cure.asm"

; -------------------------------------

; --- discard_and_ret -------------------------------------------
; @done
; Drop the caller's return address (pop af) and return to its caller.
discard_and_ret:
		pop	af
		ret

; -------------------------------------

		include "code/851A-85EB__spell_summon_monster.asm"
		include "code/85EC-8606__calc_monster_hp.asm"
		include "code/8607-861A__spell_reveal_secret.asm"
		include "code/861B-8625__spell_flee_effect.asm"
		include "code/8626-8648__spell_ac_modifier.asm"
		include "code/8649-86A9__show_location_info.asm"
		include "code/86AA-86C4__spell_attack_bonus.asm"

; -------------------------------------

; --- carpet_setup ----------------------------------------------
; @done
; Activate the levitation/carpet spell: roll duration into VAR_CARPET,
; show the carpet icon, print the trailing ellipsis.
carpet_setup:
		GET_B_FROM_TABLE	$5B

		ADD_RND_NUMBER

		ld	(GAME_VARIABLES + VAR_CARPET),a

		SHOW_ICON	ICON_CARPET

		jr	jp_print_ellipsis

; -------------------------------------

; --- compass_speed_lookup --------------------------------------
; @done
; Look up a value (table $53 index $2F) and add it as an attack bonus.
compass_speed_lookup:
		ld	c,a

		GET_IY_A_FROM_TABLE	$53,$2F

		jr	add_attack_bonus

; -------------------------------------

; --- compass_setup ---------------------------------------------
; @done
; Activate the COMPASS spell: roll VAR_COMPASS_ON, draw the compass, print ellipsis.
compass_setup:
		ADD_RND_NUMBER

		ld	(GAME_VARIABLES + VAR_COMPASS_ON),a
		call	show_compass

		jr	jp_print_ellipsis
; -------------------------------------

; --- eye_setup -------------------------------------------------
; @done
; Activate the mage EYE spell: set the speed-lookup bits and VAR_EYE
; duration, show the eye icon, print ellipsis.
eye_setup:
		rla
		rla
		rla
		and     3
		ld      (GAME_VARIABLES + VAR_SPEED_LOOKUP),a
		ld      a,b

		ADD_RND_NUMBER

		ld	(GAME_VARIABLES + VAR_EYE),a

		SHOW_ICON	ICON_EYE

		jr	jp_print_ellipsis

; -------------------------------------

; --- shield_setup ----------------------------------------------
; @done
; Activate the SHIELD spell: roll VAR_SHIELD, set icon, recalc party AC, print ellipsis.
shield_setup:
		ADD_RND_NUMBER

		ld	(GAME_VARIABLES + VAR_SHIELD),a
		ld	(iy+VAR_ICON_CODE),2

		SHOW_ICON	ICON_SHIELD

		RECALC_ALL_AC

		jr	jp_print_ellipsis

; -------------------------------------

		include "code/8706-8777__proc_teleport.asm"
		include "code/8778-87B4__adjust_value_updown.asm"
		include "code/87B5-87CF__print_plus_minus.asm"

; -------------------------------------
; --- clamp_defense_bonus ---------------------------------------
; @done
; Add the rolled defense bonus (table $59) to VAR_DEFENSE_BONUS, capped at 6.
clamp_defense_bonus:
		ld	hl,GAME_VARIABLES + VAR_DEFENSE_BONUS

		GET_B_FROM_TABLE	$59

		add	a,(hl)

		cp	6
		jr	c,.store

		ld	a,6

.store:
		ld	(hl),a

		jp	print_ellipsis

; -------------------------------------

		include "tables/87E1-881A__procs_buffer2.asm"
		include "data/881B-886C__table_6.asm"

; -------------------------------------

; --- get_top3_bits ---------------------------------------------
; @done
; Read a table byte (table $4B index $69) and return its top 3 bits in b.
get_top3_bits:
		GET_IY_A_FROM_TABLE	$4B,$69

		rlca
		rlca
		rlca
		and	7
		ld	b,a

		ret

; -------------------------------------

		include "code/8878-8881__add_rnd_number.asm"

; -------------------------------------

; --- reset_damage ----------------------------------------------
; @done
; RESET_DAMAGE dispatch: zero hl and VAR_DAMAGE_TYPE.
reset_damage:				; RESET_DAMAGE
		xor	a
		ld	h,a
		ld	l,a
		ld	(GAME_VARIABLES + VAR_DAMAGE_TYPE),a
		ret
; -------------------------------------

		include "code/8889-8895__roll_damage_dice.asm"
		include "code/8896-8899__print_ellipsis.asm"
		include "code/889A-99C9__print_N_enemies.asm"
		include "code/88CA-88E4__print_12_digits.asm"
		include "code/88E5-890C__print_large_number.asm"
		include "code/890D-891C__toggle_speed_flag.asm"

; -------------------------------------
		ret
; -------------------------------------

; --- get_hero_class --------------------------------------------
; @done
; Return the active hero's class byte (table $4B index $4A).
get_hero_class:
		GET_IY_A_FROM_TABLE	$4B,$4A

		ret
; -------------------------------------

		include "code/8923-89AD__show_name_and_pic.asm"

; -------------------------------------
		DB $62	; b
		DB $6B	; k

; ======= S U B	R O U T	I N E =========

		include "code/89B0-89CC__simple_down_hl.asm"
		include "code/89CD-8A18__interrupt.asm"
		include "code/8A19-8A51__run_dynamic.asm"
		include "code/8A52-8A5C__get_param_to_A.asm"
		include "code/8A5D-8AE9__print_A_symbol.asm"
		include "code/8AEA-8B82__print_stats_table.asm"
		include "code/8B83-8C08__print_routines.asm"
		include "tables/8C09-8CCC__procs_buffer.asm"
		include "code/8CCD-8D0C__get_from_table.asm"
		include "code/8D0D-8D47__get_attr_by_param.asm"
		include "code/8D48-8D4C__a_plus_c_to_hl.asm"
		include "code/8D4D-8DA8__show_icon.asm"
		include "code/8DA9-8DB4__show_compass.asm"
		include "tables/8DB5-8F0C__spell_names.asm"
		include "data/8F0D-8F4C__combat_lookup_tables.asm"

OPTION_KEYS:
		DB 0			; 7 = --terminator--

		include "data/8F4E-9272__monsters.asm"
		include "data/9273-93AF__combat_tables.asm"
		include "tables/93B0-93FE__spell_costs.asm"
		include "tables/93FF-945D__spell_types.asm"
		include "data/945E-94C6__table_23.asm"
		include "tables/94C7-94D2__range_values.asm"
		include "tables/94D3-94DE__light_durations.asm"
		include "tables/94DF-94EA__reveal_durations.asm"
		include "data/94EB-9555__dice_summon_tables.asm"
		include "tables/9556-9573__summon_creatures.asm"
		include "data/9574-95BE__class_eligibility.asm"
		include "tables/95BF-97DD__items.asm"
		include "data/97DE-98DE__bard_tune_table.asm"

		include "gfx/98DF-9AA6__icons.asm"

		include "code/9AA7-9AB6__call_beeper.asm"

		include "data/9AB7-9B0C__letters.asm"
		include "data/9B0D-9B94__messages_table.asm"		; rst 10 / db 7 print
		include "data/9B95-9C14__items_lengths.asm"
		include "data/9C15-9C1F__word_entry_lengths.asm"
		include "data/9C20-9CDC__words.asm"

		DB 7

		include "data/9CDE-A585__words_table.asm"		; rst 10 / db 7 print
		include "data/A586-A5EB__item_names_tail.asm"
		include "data/A5EC-BFE1__index_monster_names.asm"

		include "code/BFE2-C009__print_routines2.asm"
		include "code/C00A-C038__print_item_name_padded.asm"

; -------------------------------------

; --- print_item_name -------------------------------------------
; @done
; Print an item's name from the item name/length index tables.
; In:  a = item index
print_item_name:
		PUSH_REGS

		ex	af,af'
		xor	a
		ex	af,af'
		dec	a

; --- set_item_tables -------------------------------------------
; @done
; Alt entry: point de/hl at the item name/length index tables, then
; fall into the message printer.
set_item_tables:
		ld	de,INDEX_ITEM_NAMES
		ld	hl,INDEX_ITEM_LENGTHS
		scf

		jr	print_msg_no_cp
; -------------------------------------

; --- print_word ------------------------------------------------
; @done
; Print a dictionary word (via the shared message setup).
print_word:
		ex	af,af'
		xor	a			; print	word

		jr	print_msg_setup
; -------------------------------------

; --- print_empty -----------------------------------------------
; @done
; Print an empty line (via the shared message setup).
print_empty:
		ex	af,af'
		ld	a,1		; print	empty line

; --- print_msg_setup -------------------------------------------
; @done
; Shared front-end for print_word/print_empty/print_item_name: choose the
; name/length tables (item vs monster) by matching KEY_CODES_TABLE, then run
; the 5-bit message decoder (print_msg_A).
print_msg_setup:
		PUSH_REGS

		push	af
		ex	af,af'
		ld	bc,$12
		ld	hl,KEY_CODES_TABLE + $12 -1		; 984Ah
		cpdr
		jr	nz,.not_found	; NZ = not found

		GET_C_FROM_TABLE	$15

.not_found:
		ex	af,af'
		pop	af
		ex	af,af'
		dec	a
		ld	de,INDEX_MONSTER_NAMES
		ld	hl,INDEX_MONSTER_LENGTHS

		; -----------------------------------------
		include "code/C06A-C10E__print_msg_A.asm"
		; -----------------------------------------
; -------------------------------------

; --- msg_end_of_line -------------------------------------------
; @done
; print_msg_A line/word advance: at end of line adjust the column/word
; counters (d/e) and re-enter print_msg_loop.
msg_end_of_line:
		dec	d
		inc	d
		jr	nz,msg_wrap_word

		inc	d

		jr	print_msg_loop

; --- msg_wrap_word ---------------------------------------------
; @done
; print_msg_A word-wrap step: decrement the word counter (e) and continue.
msg_wrap_word:
		dec	e
		inc	e
		jr	nz,msg_dec_count

		dec	d

		jr	print_msg_loop

; --- msg_dec_count ---------------------------------------------
; @done
; print_msg_A count step: decrement the display count and continue print_msg_loop.
msg_dec_count:
		dec	e
		ld	a,(GAME_VARIABLES + VAR_DISPLAY_COUNT)
		and	a
		jr	z,print_msg_loop

		dec	d

		jp	print_msg_loop
; -------------------------------------

		include "code/C128-C147__print_msg_A_part_2.asm"
		include "code/C148-C171__print_from_buffer.asm"
		include "code/C172-C18B__print_IX_heroname.asm"

; ======= S U B	R O U T	I N E =========

LEVEL_START:					; C18C (49548) load 39C5 (14789) bytes of level here
		include "levels/city/code/C18C-C19D__movement_dispatch.asm"

		include "levels/city/tables/C19E-C2C1__addr_table.asm"

		include "levels/city/code/C2C2-C2DF__print_msg_A_part_3.asm"

		include "levels/city/data/C2E0-C372__messages_table_2.asm"
		include "levels/city/data/C373-CEF4__messages_texts_2.asm"
		include "levels/city/data/CEF5-D73D__location_pics_a.asm"
		include "levels/city/data/D73E-D830__location_pics_b.asm"
		include "levels/city/data/D831-E36F__location_pics_c.asm"

		include "levels/city/code/E370-E3CD__proc_shoppe.asm"
		include "levels/city/code/E3CE-E3FB__shoppe_identify.asm"
		include "levels/city/code/E3FC-E422__shoppe_sell.asm"
		include "levels/city/code/E423-E4F3__shoppe_buy.asm"
		include "levels/city/code/E4F4-E50C__shift_price_buffer.asm"
		include "levels/city/code/E50D-E54B__display_inventory_list.asm"
		include "levels/city/code/E54C-E561__get_inventory_selection.asm"

		include "levels/city/data/E562-E5E1__item_prices.asm"

		include "levels/city/code/E5E2-E5F2__print_item_price.asm"
		include "levels/city/code/E5F3-E5FF__format_item_price.asm"
		include "levels/city/code/E600-E746__proc_temple.asm"
		include "levels/city/code/E747-E7A8__proc_guild.asm"
		include "levels/city/code/E7A9-E855__proc_guardian.asm"

		include "levels/city/data/E856-E87D__guardians.asm"

		include "levels/city/code/E87E-E8A7__proc_city_sewers.asm"
		include "levels/city/code/E8A8-E8BB__compare_char_attrs.asm"
		include "levels/city/code/E8BC-E8CB__copy_char_params.asm"

		include "levels/city/data/E8CC-E8DD__temple_heal_cost.asm"
		include "levels/city/data/E8DE-E8F5__inns_data.asm"

		include "levels/city/code/E8F6-E91C__find_inn.asm"
		include "levels/city/code/E91D-E94F__proc_reviewbord.asm"
		include "levels/city/code/E950-EA54__do_advancement.asm"
		include "levels/city/code/EA55-EACD__do_spell_acquire.asm"
		include "levels/city/code/EACE-EBAA__do_class_change.asm"
		include "levels/city/code/EBAB-EBB3__adjust_stat_floor.asm"
		include "levels/city/code/EBB4-EBC2__add_16bit_carry.asm"

		include "levels/city/data/EBC3-EBD7__advancement_tables.asm"

		include "levels/city/code/EBD8-EBF5__proc_tavern.asm"
		include "levels/city/code/EBF6-EC72__order_drink.asm"
		include "levels/city/code/EC73-ECE8__talk_barkeeper.asm"

		include "levels/city/data/ECE9-ECEE__drinks_keys.asm"
		include "levels/city/data/ECEF-ED02__barkeep_rumors.asm"

		include "levels/city/code/ED03-ED0C__enter_hero_num.asm"
		include "levels/city/code/ED0D-ED2C__proc_empty_building.asm"
		include "levels/city/code/ED2D-EDB9__proc_roscoe.asm"
		include "levels/city/code/EDBA-EE0D__proc_mad_god.asm"
		include "levels/city/code/EE0E-EE57__proc_iron_gate.asm"
		include "levels/city/code/EE58-EEB3__enter_new_location.asm"
		include "levels/city/code/EEB4-EED2__proc_gate_closed.asm"
		include "levels/city/code/EED3-EF43__movement.asm"

		include "levels/city/tables/EF44-EF6F__procs_buffer3.asm"

		include "levels/city/code/EF70-EFD1__proc_sinister_street.asm"
		include "levels/city/code/EFD2-F13E__render_3d_view.asm"
		include "levels/city/code/F13F-F178__display_walls_creatures.asm"

		include "levels/city/data/F179-F1A8__view_render_tables.asm"

		include "levels/city/code/F1A9-F258__render_sprite_3d.asm"
		include "levels/city/code/F259-F28E__decode_sprite_mask.asm"
		include "levels/city/code/F28F-F3EA__create_char.asm"
		include "levels/city/code/F3EB-F416__remove_char.asm"
		include "levels/city/code/F417-F455__load_save_party.asm"
		include "levels/city/code/F456-F476__enter_filename.asm"
		include "levels/city/code/F477-F4A6__find_hero_by_name.asm"

		include "levels/city/data/F4A7-F7E6__city_sprite_data.asm"
		include "levels/city/data/F7E7-FA98__city_map.asm"

; -------------------------------------

		DB 0
		DB 1

		include "levels/city/data/FA9B-FB4F__scratch_buffer.asm"

; -------------------------------------
SOME_BUFF:
		DB $42

LEVEL_STOP:				; first address after the level data
		DB $1F,$1F,$1F,$3F,$7F,$FF,$FF,0,0,0,0

GUARDIAN_TYPE:
		DB 0

byte_FB5D:
		DB 0

byte_FB5E:
		DB 0
		DB 0
		DB $1A

PARTY_HEADER:
		DB $1A

TEXT_BUFFER:
		DB $1A

byte_FB63:
		DB $1A,$1A,0,$1A,0,0,0,$FF
		DB $FF,0,0,0,0,$55,$FF,$55

DISPLAY_PALETTE:
		DB $55,$FF,$55,$55,0,$F4,$F4,$FC
		DB $FC,$FD,$FF,$FF,$FF,$73,$73,$73
		DB $30,0,$43,$FF,$FF,$F1,$D0,$4F
		DB $4F,$C4,$D1,$FF,$FF

ACTIVE_GUARDIAN:	
		DB $50,$50,$50,0,0,0,0,0

COMBAT_ACTIVE_FLAG:
		DB $0A

byte_FB99:
		DB $58,$70,$70,$70,$58,$0A

FILEHEADER_BUFF:
		DB 0

sentence:
		DB $A0,$70,$58,$58,$58,$70,$A0,0,0,$AA,$50,$FA,$50,$AA,0,0
		DB 0,$50,$50,$FA

SPELL_LIGHT_STATE:
		DB $50,$50,0,0,0

SPELL_REVEAL_STATE:
		DB 0,0,0,0,$50

SPELL_SECRET_STATE:
		DB $50,$30,0,0,0

SPELL_COMPASS_STATE:
		DB $FA,$FA,0,0,0
		
SPELL_CARPET_STATE:
		DB 0,0,0,0,0

SPELL_SHIELD_STATE:
		DB $50,$50,0,0,0

SPELL_EYE_STATE:
		DB $FF,$FF,3,3,3

VIEW_CELL_0:	DB 3
VIEW_CELL_1:	DB $D8
VIEW_FAR_CENTRE:	DB $AA
VIEW_CELL_3:	DB $AA
VIEW_CELL_4:	DB $AA
VIEW_MID_CENTRE:	DB $AA
VIEW_CELL_6:	DB $AA
VIEW_CELL_7:	DB $D8
VIEW_NEAR_CENTRE:	DB 0
		DB $50

GAME_PARAM_COPY:
		DB $70,$50,$50,$50,$50,$72,0,$78
		DB $AA,$0A,$18,$60,$A0,$FA,0,$72
		DB $AA,$0A,$52,$0A,$AA,$72,0,$AA
		DB $AA,$AA,$FA,$0A,$0A,$0A,0,$FA
		DB $A0,$A0,$F2,$0A,$AA,$78,0,$D8
		DB $AA,$A0,$F8,$AA,$AA,$D8,0,$FA
		DB $0A,$18,$50

sentence_2:
		DB $50,$50,$50,0,$D8,$AA,$AA,$D8,$AA,$AA
		DB $D8,0,$78,$AA,$AA,$7A,$0A,$AA,$78,0

some_buff_copy:
		DB 0,$50,$50
		DB 0,$50,$50
		DB 0,0,0
		DB 0,$50,$50
		DB 0,$50,$50
		DB $60

		include "gfx/FC38-FCE1__partial_font.asm"
		include "data/FCE2-FF78__gfx_and_ui_data.asm"

boot_scr_save:
		DW $3D00

		DB 9
		DB 6
		DB 8
		DB $7E
		DB $12
		DB $14
		DB $23
		DB $10
		DB $FA
		DB $E1
		DB $23
		DB $1C
		DB $7A
		DB $D6
		DB 8
		DB $57
		DB $18
		DB $E0
		DB $C9
; -------------------------------------

		include "code/FF8E-FFE1__loader.asm"

; -------------------------------------
		DB $42
		DB $42
		DB $7C
		DB $44
		DB $42
		DB 0
		DB 0
		DB $3C
		DB $40
		DB $3C
		DB 2
		DB $42
		DB $3C
		DB 0
		DB 0
		DB $FE
		DB $10
		DB $10
		DB $10
		DB $10
		DB $10
		DB 0
		DB 0
		DB $42
		DB $42
		DB $42
		DB $42
		DB $42
		DB $3C

; ======= S U B	R O U T	I N E =========


STACK:
		nop
