; -------------------------------------
		include "constants.asm"
		include "constants_guild.asm"
		include "code/macroses.asm"

binary_start:
; -------------------------------------
		jp	INIT_GAME
; -------------------------------------

		include "code/5B03-5B3D_game_cycle.asm"
		include "code/5B3E-5B7C_press_hero_number.asm"
		include "code/5B7D-5B8A_print_spaces_eol.asm"
		include "code/5B8B-5BA7_print_hero_attr.asm"
		include "code/5BA8-5BE0_get_pressed_key.asm"
		include "code/5BE1-5C16_print_number.asm"
		include "code/5C17-5C50___UNKNOWN.asm"

; -------------------------------------
		dw off_5C53
off_5C53:
		dw run_dynamic

		include "data/5C55-5C5C_UNKNOWN_TABLE_1.asm"
		include "data/5C5D-5C64_UNKNOWN_TABLE_2.asm"
; -------------------------------------

JP_INTERRUPT:
		jp	interrupt

; -------------------------------------
PARTY_FILE:
		db    0,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh
		db 0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh
		db 0FFh,0FFh,0FFh,   0,	  0,   0,   0

		include "data/5C83-5FAA_heroes.asm"
		include "data/5FAB-6022_game_variables.asm"

		include "code/6023-6052_INIT_GAME.asm"
		include "code/6053-605D_wait_key_down.asm"
		include "code/605E-60A4_process_game_turn.asm"
		include "code/60A5-6154_process_daynight.asm"
		include "code/6155-6166_nullify_buffer.asm"
		include "code/6167-6175_print_letter_pair.asm"

		include "tables/6176-61D7_statuses.asm"

		include "code/61D8-61F4_find_hero.asm"
		include "code/61F5-6204_check_hero_status.asm"
		include "code/6205-621A_clear_info_panl.asm"
		include "code/621B-6232_prnt_space_line.asm"
		include "code/6233-6298_enter_text.asm"
		include "code/6299-62A9_print_yesno_wait.asm"
		include "code/62AA-62E6_print_loc_name.asm"
		include "code/62E7-62F6_show_name_pic_AB.asm"
		include "code/62F7-645F_load_save_file.asm"

		include "data/6460-649B_UNKNOWN.asm"

		include "code/649C-64BF_push_pop_regs.asm"
		include "code/64C0-64C9_get_rnd_by_param.asm"
		include "code/64CA-64DB___UNKNOWN.asm"
		include "code/64DC-64F2_exec_for_heroes.asm"
		include "code/64F3-6569_city_colors.asm"
		include "code/656A-65FE___UNKNOWN.asm"
		include "code/65FF-6615_zero_buffers.asm"
		include "code/6616-6629_calculate_addr.asm"
		include "code/662A-6699_encounter.asm"
		include "code/669A-6705___UNKNOWN.asm"
		include "code/6706-6712_swap_byte_buffer.asm"
		include "code/6713-6733_show_some_pictext.asm"
		include "code/6734-6745_clear_txt_buffer.asm"
		include "code/6746-680C___UNKNOWN.asm"
		include "code/680D-6857___UNKNOWN.asm"
		include "code/6858-68AC_fight_or_run.asm"
		include "code/68AD-6914_battle_options.asm"
		include "code/6915-6976_option_is_found.asm"
		include "code/6977-69B7___UNKNOWN.asm"
		include "code/69B8-6A02_battle_play_tune.asm"
		include "code/6A03-6A26___UNKNOWN.asm"
		include "code/6A27-6A48___UNKNOWN.asm"
		include "code/6A49-6A65_get_rnd_numbers.asm"
		include "code/6A66-6AC5___UNKNOWN.asm"
		include "code/6AC6-6ACB_divide_A_by_8.asm"
		include "code/6ACC-6B23___UNKNOWN.asm"
		include "code/6B24-6B64_print_hero_items.asm"
		include "code/6B65-6BC1_process_spell.asm"
		include "code/6BC2-6C82___UNKNOWN.asm"
		include "code/6C83-6CAA_print_memb_num.asm"

; -------------------------------------


sub_6CAB:
		add	a, 42h ; 'B'
		ld	(GAME_VARIABLES + VAR_70), a

		ret

; ======= S U B	R O U T	I N E =========


sub_6CB1:
		push	af
		ld	hl, GAME_VARIABLES + VAR_70
		ld	b, 3
		call	nullify_buffer
		pop	af

		ret

; -------------------------------------

		include "code/6CBC-6CCE_count_heroes.asm"
		include "code/6CCF-6CD6_print_group.asm"
		include "code/6CD7-6D04_check_equipped.asm"
		include "code/6D05-6D2B___UNKNOWN.asm"

; -------------------------------------

dyn_proc_95:				; RST_10_5D
		ld	b, 3

loc_6D2E:
		GET_B_FROM_TABLE	36h

		ret	nz

		dec	b
		jp	p, loc_6D2E

		scf

		ret

; ======= S U B	R O U T	I N E =========


sub_6D38:
		call	sub_6D40
		ld	a, 0Eh
		call	print_spaces_eol

sub_6D40:
		ld	hl, 10Eh
		ld	(GAME_VARIABLES + VAR_CURSOR_ROW), hl

		ret

; -------------------------------------

		include "code/6D47-70A9_combat_foes.asm"
		include "code/70AA-70BB_attack_and_result.asm"
		include "code/70BC-70D6_show_damage.asm"
		include "code/70D7-713C_new_order.asm"

; ======= S U B	R O U T	I N E =========


sub_713D:
		PUSH_REGS

		ld	a, 72h		; monsters magic

		jp	loc_714B
; -------------------------------------

		include "code/7144-719A___UNKNOWN.asm"
		include "code/719B-71AF___UNKNOWN.asm"
		include "code/71B0-7226_print_hero_stats.asm"
		include "code/7227-722C_print_and_wait.asm"
		include "code/722D-72DC_trade_gold.asm"
		include "code/72DD-72F6_drop_item.asm"
		include "code/72F7-7304_all_full.asm"
		include "code/7305-7362_equip_item.asm"
		include "code/7363-737E_enter_number.asm"
		include "code/737F-73A5_print_magic_attrs.asm"
		include "code/73A6-73E7___UNKNOWN.asm"

		include "tables/73E8-7405_procs_actions.asm"

; ======= S U B	R O U T	I N E =========


sub_7406:
		ld	a, 6
		ld	c, 4

		jr	loc_73B0

; -------------------------------------

		include "code/740C-742D_cast_spell.asm"
		include "code/742E-7433_print_who_will.asm"
		include "code/7434-74BF_play_song.asm"
		include "code/74C0-7533_use_item.asm"

; -------------------------------------

if_FB98_is_zero:
		ld	a, (___table_85)
		or	a

		ret
; -------------------------------------

		include "code/7539-758F_who_cast_spell.asm"
		include "code/7590-75A4___UNKNOWN.asm"
		include "code/75A5-75BE___UNKNOWN.asm"
		include "code/75BF-7624___UNKNOWN.asm"
		include "code/7625-7638___UNKNOWN.asm"
		include "code/7639-7663___UNKNOWN.asm"
		include "code/7664-768F_print_hero_attrib.asm"
		include "code/7690-76B8_shoppe_pool_gold.asm"
		include "code/76B9-76EC___UNKNOWN.asm"
		include "code/76ED-771B_increas_12_digits.asm"
		include "code/771C-773B___UNKNOWN.asm"
		include "code/773C-7757_copy_hero_money.asm"
		include "code/7758-7765_is_roster_full.asm"
		include "code/7766-7779___UNKNOWN.asm"

; -------------------------------------

get_attr_param:
		PUSH_REGS

		call	sub_7785
		ex	de, hl
		ld	hl, addr_FB5B

		jr	loc_7793

; ======= S U B	R O U T	I N E =========


sub_7785:
		ld	a, e
		add	a, 0Bh

		jp	get_attr_by_A

; -------------------------------------

		include "code/778B-77AF_decreas_12_digits.asm"
		include "code/77B0-77D7___UNKNOWN.asm"
		include "code/77B8-77FF_unpack_hero_attrs.asm"
		include "code/7800-7827_pack_hero_attrs.asm"
		include "code/7828-78A7___UNKNOWN.asm"
		include "code/78A8-78CB___UNKNOWN.asm"
		include "code/78CC-78D9___UNKNOWN.asm"
		include "code/78DA-7905_process_poison.asm"
		include "code/7906-794C___UNKNOWN.asm"
		include "code/794D-7966___UNKNOWN.asm"
		include "code/7967-7A31___UNKNOWN.asm"
		include "code/7A32-7A49_clean_ally_memory.asm"
		include "code/7A4A-7A66_clean_hero_memory.asm"
		include "code/7A67-7A9D___UNKNOWN.asm"
		include "code/7A9E-7AB7___UNKNOWN.asm"
		include "code/7AB8-7BEC___UNKNOWN.asm"
		include "code/7BED-7BF3_divide_A_by_16.asm"
		include "code/7BF4-7C4D___UNKNOWN.asm"
		include "code/7C4E-7CD2___UNKNOWN.asm"
		include "code/7CD3-7DB3___UNKNOWN.asm"

		include "data/7DB4-7DB7_UNKNOWN_TABLE_3.asm"

; ======= S U B	R O U T	I N E =========

		include "code/7DB8-7DF8___UNKNOWN.asm"
		include "code/7DF9-7E37___UNKNOWN.asm"
		include "code/7E38-7F78_enemies_killed.asm"
		include "code/7F79-7FB2___UNKNOWN.asm"
		include "code/7FB3-7FF1___UNKNOWN.asm"
		include "code/7FF2-8064___UNKNOWN.asm"
		include "code/8065-806C_dummy_pause.asm"

; -------------------------------------

dyn_proc_54:						; RST_10_29
		PUSH_REGS

		ld	e, 1

		GET_IY_A_FROM_TABLE	58h, 27h

		jr	loop_speed
; -------------------------------------

		include "code/8077-80BB_change_speed.asm"
		include "code/80BC-80D3_set_pause.asm"
		include "code/80D4-80FA_oh_dear_game_over.asm"
		include "code/80FB-810D_choose_hero.asm"
		include "code/810E-816E_spell_casting.asm"
		include "code/816E-819A_light_the_light.asm"
		include "code/819B-81D4___UNKNOWN.asm"
		include "code/81D5-82BD___UNKNOWN.asm"
		include "code/82BE-82D1___UNKNOWN.asm"

; ======= S U B	R O U T	I N E =========


sub_82D2:
		ld	(iy+VAR_10), 0

		ret

; -------------------------------------

		include "code/82D7-82FB___UNKNOWN.asm"

		include "data/82FC-8313_UNKNOWN.asm"

		include "code/8314-8412___UNKNOWN.asm"
		include "code/8413-8496___UNKNOWN.asm"
		include "code/8497-8517___UNKNOWN.asm"

; -------------------------------------

loc_8518:
		pop	af
		ret

; -------------------------------------

		include "code/851A-85EB___UNKNOWN.asm"
		include "code/85EC-8606___UNKNOWN.asm"
		include "code/8607-861A___UNKNOWN.asm"
		include "code/861B-8625___UNKNOWN.asm"
		include "code/8626-8648___UNKNOWN.asm"
		include "code/8649-86A9___UNKNOWN.asm"
		include "code/86AA-86C4___UNKNOWN.asm"

; -------------------------------------

carpet_setup:
		GET_B_FROM_TABLE	5Bh

		ADD_RND_NUMBER

		ld	(GAME_VARIABLES + VAR_CARPET), a

		SHOW_ICON	ICON_CARPET

		jr	jp_print_ellipsis

; -------------------------------------

loc_86D2:
		ld	c, a

		GET_IY_A_FROM_TABLE	53h, 2Fh

		jr	loc_86C0

; -------------------------------------

compass_setup:
		ADD_RND_NUMBER

		ld	(GAME_VARIABLES + VAR_COMPASS_ON), a
		call	show_compass

		jr	jp_print_ellipsis
; -------------------------------------

eye_setup:
		rla
		rla
		rla
		and     3
		ld      (GAME_VARIABLES + VAR_59), a
		ld      a, b

		ADD_RND_NUMBER

		ld	(GAME_VARIABLES + VAR_EYE), a

		SHOW_ICON	ICON_EYE

		jr	jp_print_ellipsis

; -------------------------------------

shield_setup:
		ADD_RND_NUMBER

		ld	(GAME_VARIABLES + VAR_SHIELD), a
		ld	(iy+VAR_55), 2

		SHOW_ICON	ICON_SHIELD

		RST_10_4A

		jr	jp_print_ellipsis

; -------------------------------------

		include "code/8706-8777_proc_teleport.asm"
		include "code/8778-87B4___UNKNOWN.asm"
		include "code/87B5-87CF_print_plus_minus.asm"

; -------------------------------------
loc_87D0:
		ld	hl, GAME_VARIABLES + VAR_60

		GET_B_FROM_TABLE	59h

		add	a, (hl)

		cp	6
		jr	c, loc_87DD

		ld	a, 6

loc_87DD:
		ld	(hl), a

		jp	print_ellipsis

; -------------------------------------

		include "tables/87E1-881A_procs_buffer2.asm"
		include "data/881B-886C_UNKNOWN.asm"

; -------------------------------------

loc_886D:
		GET_IY_A_FROM_TABLE	4Bh, 69h

		rlca
		rlca
		rlca
		and	7
		ld	b, a

		ret

; -------------------------------------

		include "code/8878-8881_add_rnd_number.asm"

; -------------------------------------

dyn_proc_80:				; RST_10_49
		xor	a
		ld	h, a
		ld	l, a
		ld	(GAME_VARIABLES + VAR_50), a
		ret
; -------------------------------------

		include "code/8889-8895___UNKNOWN.asm"
		include "code/8896-8899_print_ellipsis.asm"
		include "code/889A-99C9_print_N_enemies.asm"
		include "code/88CA-88E4_print_12_digits.asm"
		include "code/88E5-890C___UNKNOWN.asm"
		include "code/890D-891C___UNKNOWN.asm"

; -------------------------------------
		ret
; -------------------------------------

loc_891E:
		GET_IY_A_FROM_TABLE	4Bh, 4Ah

		ret
; -------------------------------------

		include "code/8923-89AD_show_name_and_pic.asm"

; -------------------------------------
		db  62h	; b
		db  6Bh	; k

; ======= S U B	R O U T	I N E =========

		include "code/89B0-89CC_simple_down_hl.asm"
		include "code/89CD-8A18_interrupt.asm"
		include "code/8A19-8A51_run_dynamic.asm"
		include "code/8A52-8A5C_get_param_to_A.asm"
		include "code/8A5D-8AE9_print_A_symbol.asm"
		include "code/8AEA-8B82_print_stats_table.asm"
		include "code/8B83-8C08_print_routines.asm"
		include "tables/8C09-8CCC_procs_buffer.asm"
		include "code/8CCD-8D0C_get_from_table.asm"
		include "code/8D0D-8D47_get_attr_by_param.asm"
		include "code/8D48-8D4C_a_plus_c_to_hl.asm"
		include "code/8D4D-8DA8_show_icon.asm"
		include "code/8DA9-8DB4_show_compass.asm"
		include "tables/8DB5-8F0C_spell_names.asm"
		include "data/8F0D-8F4C_UNKNOWN_TABLE_7.asm"

OPTION_KEYS:
		db    0			; 7 = --terminator--

		include "data/8F4E-9272_monsters.asm"
		include "data/9273-93AF_UNKNOWN.asm"
		include "tables/93B0-93FE_spell_costs.asm"
		include "tables/93FF-945D_spell_types.asm"
		include "data/945E-94C6_UNKNOWN.asm"
		include "tables/94C7-94D2_range_values.asm"
		include "tables/94D3-94DE_light_durations.asm"
		include "tables/94DF-94EA_reveal_durations.asm"
		include "data/94EB-9555_UNKNOWN.asm"
		include "tables/9556-9573_summon_creatures.asm"
		include "data/9574-95BE_UNKNOWN.asm"
		include "tables/95BF-97DD_items.asm"
		include "data/97DE-98DE_UNKNOWN.asm"

		include "gfx/98DF-9AA6_icons.asm"

		include "code/9AA7-9AB6_call_beeper.asm"

		include "data/9AB7-9B0C_letters.asm"
		include "data/9B0D-9B94_messages_table.asm"		; rst 10 / db 7 print
		include "data/9B95-9C14_items_lengths.asm"
		include "data/9C0D-9C1F_UNKNOWN.asm"
		include "data/9C20-9CDC_words.asm"

		db    7

		include "data/9CDE-A585_words_table.asm"		; rst 10 / db 7 print
		include "data/A586-A5EB_UNKNOWN.asm"
		include "data/A5EC-BFE1_UNKNOWN.asm"

		include "code/BFE2-C009_print_routines2.asm"
		include "code/C00A-C038___UNKNOWN.asm"

; -------------------------------------

print_item_name:
		PUSH_REGS

		ex	af, af'
		xor	a
		ex	af, af'
		dec	a

loc_C03F:
		ld	de, INDEX_ITEM_NAMES
		ld	hl, INDEX_ITEM_LENGTHS
		scf

		jr	print_msg_no_cp
; -------------------------------------

print_word:
		ex	af, af'
		xor	a			; print	word

		jr	loc_C04F
; -------------------------------------

print_empty:
		ex	af, af'
		ld	a, 1		; print	empty line

loc_C04F:
		PUSH_REGS

		push	af
		ex	af, af'
		ld	bc, 12h
		ld	hl, ___table_45 + 12h -1		; 984Ah
		cpdr
		jr	nz, loc_C060	; NZ = not found

		GET_C_FROM_TABLE	15h

loc_C060:
		ex	af, af'
		pop	af
		ex	af, af'
		dec	a
		ld	de, INDEX_MONSTER_NAMES
		ld	hl, INDEX_MONSTER_LENGTHS

		; -----------------------------------------
		include "code/C06A-C10E_print_msg_A.asm"
		; -----------------------------------------
; -------------------------------------

loc_C10F:
		dec	d
		inc	d
		jr	nz, loc_C116

		inc	d

		jr	loc_C0B0

loc_C116:
		dec	e
		inc	e
		jr	nz, loc_C11D

		dec	d

		jr	loc_C0B0

loc_C11D:
		dec	e
		ld	a, (GAME_VARIABLES + VAR_4F)
		and	a
		jr	z, loc_C0B0

		dec	d

		jp	loc_C0B0
; -------------------------------------

		include "code/C128-C147_print_msg_A_part_2.asm"
		include "code/C148-C171_print_from_buffer.asm"
		include "code/C172-C18B_print_IX_heroname.asm"

; ======= S U B	R O U T	I N E =========

LEVEL_START:					; C18C (49548) load 39C5 (14789) bytes of level here
		include "levels/city/code/C18C-C19D___UNKNOWN.asm"

		include "levels/city/tables/C19E-C2C1_addr_table.asm"

		include "levels/city/code/C2C2-C2DF_print_msg_A_part_3.asm"

		include "levels/city/data/C2E0-C372_messages_table_2.asm"
		include "levels/city/data/C373-CEF4_messages_texts_2.asm"
		include "levels/city/data/CEF5-D73D_UNKNOWN.asm"
		include "levels/city/data/D73E-D830_UNKNOWN.asm"
		include "levels/city/data/D831-E36F_UNKNOWN.asm"

		include "levels/city/code/E370-E3CD_proc_shoppe.asm"
		include "levels/city/code/E3CE-E3FB_shoppe_identify.asm"
		include "levels/city/code/E3FC-E422_shoppe_sell.asm"
		include "levels/city/code/E423-E4F3_shoppe_buy.asm"
		include "levels/city/code/E4F4-E50C___UNKNOWN.asm"
		include "levels/city/code/E50D-E54B___UNKNOWN.asm"
		include "levels/city/code/E54C-E561___UNKNOWN.asm"

		include "levels/city/data/E562-E5E1_UNKNOWN.asm"

		include "levels/city/code/E5E2-E5F2_print_item_price.asm"
		include "levels/city/code/E5F3-E5FF___UNKNOWN.asm"
		include "levels/city/code/E600-E746_proc_temple.asm"
		include "levels/city/code/E747-E7A8_proc_guild.asm"
		include "levels/city/code/E7A9-E855_proc_guardian.asm"

		include "levels/city/data/E856-E87D_guardians.asm"

		include "levels/city/code/E87E-E8A7_proc_city_sewers.asm"
		include "levels/city/code/E8A8-E8BB___UNKNOWN.asm"
		include "levels/city/code/E8BC-E8CB___UNKNOWN.asm"

		include "levels/city/data/E8CC-E8DD_UNKNOWN.asm"
		include "levels/city/data/E8DE-E8F5_inns_data.asm"

		include "levels/city/code/E8F6-E91C_find_inn.asm"
		include "levels/city/code/E91D-E94F_proc_reviewbord.asm"
		include "levels/city/code/E950-EA54_do_advancement.asm"
		include "levels/city/code/EA55-EACD_do_spell_acquire.asm"
		include "levels/city/code/EACE-EBAA_do_class_change.asm"
		include "levels/city/code/EBAB-EBB3___UNKNOWN.asm"
		include "levels/city/code/EBB4-EBC2___UNKNOWN.asm"

		include "levels/city/data/EBC3-EBD7_UNKNOWN.asm"

		include "levels/city/code/EBD8-EBF5_proc_tavern.asm"
		include "levels/city/code/EBF6-EC72_order_drink.asm"
		include "levels/city/code/EC73-ECE8_talk_barkeeper.asm"

		include "levels/city/data/ECE9-ECEE_drinks_keys.asm"
		include "levels/city/data/ECEF-ED02_UNKNOWN.asm"

		include "levels/city/code/ED03-ED0C_enter_hero_num.asm"
		include "levels/city/code/ED0D-ED2C_proc_empty_building.asm"
		include "levels/city/code/ED2D-EDB9_proc_roscoe.asm"
		include "levels/city/code/EDBA-EE0D_proc_mad_god.asm"
		include "levels/city/code/EE0E-EE57_proc_iron_gate.asm"
		include "levels/city/code/EE58-EEB3_enter_new_location.asm"
		include "levels/city/code/EEB4-EED2_proc_gate_closed.asm"
		include "levels/city/code/EED3-EF43_movement.asm"

		include "levels/city/tables/EF44-EF6F_procs_buffer3.asm"

		include "levels/city/code/EF70-EFD1___UNKNOWN.asm"
		include "levels/city/code/EFD2-F13E___UNKNOWN.asm"
		include "levels/city/code/F13F-F178___UNKNOWN.asm"

		include "levels/city/data/F179-F1A8_UNKNOWN.asm"

		include "levels/city/code/F1A9-F258___UNKNOWN.asm"
		include "levels/city/code/F259-F28E___UNKNOWN.asm"
		include "levels/city/code/F28F-F3EA_create_char.asm"
		include "levels/city/code/F3EB-F416_remove_char.asm"
		include "levels/city/code/F417-F455_load_save_party.asm"
		include "levels/city/code/F456-F476_enter_filename.asm"
		include "levels/city/code/F477-F4A6_find_hero_by_name.asm"

		include "levels/city/data/F4A7-F7E6_UNKNOWN.asm"
		include "levels/city/data/F7E7-FA98_city_map.asm"

; -------------------------------------

		db    0
		db    1

		include "levels/city/data/FA9B-FB4F_UNKNOWN.asm"

; -------------------------------------
SOME_BUFF:
		db  42h

LEVEL_STOP:				; first address after the level data
		db 1Fh, 1Fh, 1Fh,	3Fh, 7Fh,0FFh,0FFh,   0,   0,	0,   0

___table_82:
		db    0

byte_FB5D:
		db 0

byte_FB5E:
		db 0
		db    0
		db  1Ah

PARTY_HEADER:
		db 1Ah

TEXT_BUFFER:
		db 1Ah

byte_FB63:
		db  1Ah, 1Ah,  0, 1Ah, 0,  0,  0, 0FFh
		db	0FFh,    0,    0,     0,     0,  55h, 0FFh,  55h

___table_83:
		db	55h,  0FFh,  55h,  55h,     0, 0F4h, 0F4h, 0FCh
		db  0FCh, 0FDh, 0FFh, 0FFh, 0FFh,  73h,   73h,  73h
		db  30h,     0,   43h, 0FFh, 0FFh, 0F1h, 0D0h,  4Fh
		db  4Fh, 0C4h, 0D1h, 0FFh, 0FFh

___table_84:	
		db 50h, 50h, 50h, 0, 0, 0, 0, 0

___table_85:
		db 0Ah

byte_FB99:
		db 58h, 70h, 70h, 70h, 58h, 0Ah

FILEHEADER_BUFF:
		db 0

sentence:
		db 0A0h, 70h, 58h, 58h,	58h, 70h,0A0h,	 0,   0,0AAh, 50h,0FAh,	50h,0AAh,   0,	 0
		db 0, 50h, 50h, 0FAh

___table_86:
		db 50h, 50h, 0, 0, 0

___table_87:
		db 0, 0, 0, 0, 50h

___table_88:
		db 50h, 30h, 0, 0, 0

___table_89:
		db 0FAh, 0FAh, 0, 0, 0
		
___table_90:
		db 0, 0, 0, 0, 0

___table_91:
		db 50h, 50h, 0, 0, 0

___table_92:
		db 0FFh, 0FFh, 3, 3, 3

byte_FBD7:	db 3
byte_FBD8:	db 0D8h
byte_FBD9:	db 0AAh
byte_FBDA:	db 0AAh
byte_FBDB:	db 0AAh
byte_FBDC:	db 0AAh
byte_FBDD:	db 0AAh
byte_FBDE:	db 0D8h
byte_FBDF:	db 0
		db  50h

GAME_PARAM_COPY:
		db  70h, 50h, 50h, 50h,	50h, 72h,   0, 78h
		db 0AAh, 0Ah, 18h, 60h,0A0h,0FAh,   0, 72h
		db 0AAh, 0Ah, 52h, 0Ah,0AAh, 72h,   0,0AAh
		db 0AAh,0AAh,0FAh, 0Ah,	0Ah, 0Ah,   0,0FAh
		db 0A0h,0A0h,0F2h, 0Ah,0AAh, 78h,   0,0D8h
		db 0AAh,0A0h,0F8h,0AAh,0AAh,0D8h,   0,0FAh
		db  0Ah, 18h, 50h

sentence_2:
		db  50h, 50h, 50h,   0,0D8h,0AAh,0AAh,0D8h,0AAh,0AAh
		db 0D8h,   0, 78h,0AAh,0AAh, 7Ah, 0Ah,0AAh, 78h,   0

some_buff_copy:
		db    0, 50h, 50h
		db    0, 50h, 50h
		db    0, 0, 0
		db    0, 50h, 50h
		db    0, 50h, 50h
		db  60h

		include "gfx/FC38-FCE1_partial_font.asm"
		include "data/FCE2-FF78_UNKNOWN.asm"

word_FF79:
		dw 3D00h

		db    9
		db    6
		db    8
		db  7Eh
		db  12h
		db  14h
		db  23h
		db  10h
		db 0FAh
		db 0E1h
		db  23h
		db  1Ch
		db  7Ah
		db 0D6h
		db    8
		db  57h
		db  18h
		db 0E0h
		db 0C9h
; -------------------------------------

		include "code/FF8E-FFE1_loader.asm"

; -------------------------------------
		db  42h
		db  42h
		db  7Ch
		db  44h
		db  42h
		db    0
		db    0
		db  3Ch
		db  40h
		db  3Ch
		db    2
		db  42h
		db  3Ch
		db    0
		db    0
		db 0FEh
		db  10h
		db  10h
		db  10h
		db  10h
		db  10h
		db    0
		db    0
		db  42h
		db  42h
		db  42h
		db  42h
		db  42h
		db  3Ch

; ======= S U B	R O U T	I N E =========


STACK:
		nop
