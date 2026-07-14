; ============================================================================
; The Bard's Tale (ZX Spectrum) - Level 05 = SEWERS 3
; "An old statue of a fifteen foot tall warrior" / "Seek the Snare from behind
;  the scenes" / "The hand of time writes and cannot erase" (see TEXT via
;  levels/level_05/data/C320-C6CF__messages_texts.decoded.txt). Kylearan lore.
; ----------------------------------------------------------------------------
; 14789-byte dungeon overlay, org $C18C. Same FORMAT as level_02/03/04.
; CARVE STATUS: fully carved + byte-exact. Front matter, handlers (68/69 named +
; @done, dot-locals, In/Out headers), wall_element_table (DW-of-labels), maze planes
; (DB grids) are source; sprites 00..43 single-sourced (shared Sewers set). Remaining
; incbin = irreducible data. all handlers named + @done. See CARVE.md.
;
; Region map (all boundaries measured, byte-exact):
;   $C18C-$C2DF  front_matter (dispatch + ADDR_TABLE + decoder)         [source]
;   $C2E0-$C31F  MESSAGES_TABLE                                         [DB]
;   $C320-$C6CF  MESSAGES_TEXTS (5-bit packed)                          [incbin]
;   $C6D0-$D1F8  level_tbl_1..6 (no pad; text is short this level)      [incbin]
;   $D1F9-$DC6B  handler code (68/69 named, split one-file-per-routine)  [source]
;   $DC6C-$DDFB  wall_element_table (DW-of-sprite-labels)               [source]
;   $DDFC-$F097  sprites 00..43 (SHARED Sewers set)                     [shared]
;   $F098-$F0F3  sprite_44 / tail (level-specific, 92B)                 [incbin]
;   $F0F4-$F1DD  pixel_shift_table (tail SHIFTED this level)            [incbin]
;   $F1DE-$F2E9  gfx_xlat_table (level-specific pixel table)            [incbin]
;   $F2EA-$F6B1  maze planes (MAZE_WALLS + MAZE_FEATURES, DB grids)      [source]
;   $F6B2-$FA3F  maze_tail                                              [incbin]
;   $FA40-$FB50  special_loc_list                                       [incbin]
;
; Dispatch: handle_move_key $DB08 / refresh_dungeon_view $D40D / process_turn
;   $DC3C / handle_wandering_creature $D7CE / handle_chest $D5E3 / scan_cells_ahead $D3A2
; ============================================================================

	include "levels/level_05/code/C18C-C2DF__front_matter.asm"

MESSAGES_TABLE:
		DB $07,$11,$24,$0A,$14,$20,$1A,$79,$07,$0C,$09,$0B,$13,$15,$12,$18
		DB $15,$13,$1B,$76,$20,$18,$0A,$09,$72,$0D,$0B,$04,$17,$09,$42,$09
		DB $35,$1A,$07,$4E,$50,$26,$1C,$0D,$0C,$05,$0C,$18,$12,$2F,$2F,$3A
		DB $12,$02,$04,$0B,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00

MESSAGES_TEXTS:
	incbin "levels/level_05/data/C320-C6CF__messages_texts.bin"

level_tbl_1:
	incbin "levels/level_05/data/C6D0-C850__level_tbl_1.bin"
level_tbl_2:
	incbin "levels/level_05/data/C851-C9E6__level_tbl_2.bin"
level_tbl_3:
	incbin "levels/level_05/data/C9E7-CC7E__level_tbl_3.bin"
level_tbl_4:
	incbin "levels/level_05/data/CC7F-CE1C__level_tbl_4.bin"
level_tbl_5:
	incbin "levels/level_05/data/CE1D-CFE2__level_tbl_5.bin"
level_tbl_6:
	incbin "levels/level_05/data/CFE3-D1F8__level_tbl_6.bin"

sewers3_handlers:
	include "levels/level_05/code/D1F9-D209__get_cell_feature.asm"
	include "levels/level_05/code/D20A-D271__process_cell_features.asm"
	include "levels/level_05/code/D272-D27A__set_state_and_redraw.asm"
	include "levels/level_05/code/D27B-D2B1__mask_cell_byte.asm"
	include "levels/level_05/code/D2B2-D2BD__dispatch_scan_loop.asm"
	include "levels/level_05/code/D2BE-D2CD__ev_spin_facing.asm"
	include "levels/level_05/code/D2CE-D2D7__ev_smoke.asm"
	include "levels/level_05/code/D2D8-D2F5__ev_start_encounter.asm"
	include "levels/level_05/code/D2F6-D2FA__ev_damage_all.asm"
	include "levels/level_05/code/D2FB-D2FF__ev_inc_2f.asm"
	include "levels/level_05/code/D300-D304__ev_inc_3e.asm"
	include "levels/level_05/code/D305-D317__ev_show_number.asm"
	include "levels/level_05/code/D318-D322__ev_dispatch_smc.asm"
	include "levels/level_05/code/D323-D32F__ev_dispatch_run.asm"
	include "levels/level_05/code/D330-D344__ev_set_flags.asm"
	include "levels/level_05/code/D345-D364__ev_teleport.asm"
	include "levels/level_05/code/D365-D3A1__damage_all_groups.asm"
	include "levels/level_05/code/D3A2-D3D9__scan_cells_ahead.asm"
	include "levels/level_05/code/D3DA-D40C__announce_nearby.asm"
	include "levels/level_05/code/D40D-D417__refresh_dungeon_view.asm"
	include "levels/level_05/code/D418-D468__redraw_location.asm"
	include "levels/level_05/code/D469-D477__maze_cell_addr.asm"
	include "levels/level_05/code/D478-D49B__render_wall_face0.asm"
	include "levels/level_05/code/D49C-D4BF__render_wall_face1.asm"
	include "levels/level_05/code/D4C0-D4E4__render_wall_face2.asm"
	include "levels/level_05/code/D4E5-D508__render_wall_face3.asm"
	include "levels/level_05/code/D509-D517__get_walls_e.asm"
	include "levels/level_05/code/D518-D526__get_walls_w.asm"
	include "levels/level_05/code/D527-D535__get_walls_n.asm"
	include "levels/level_05/code/D536-D544__get_walls_s.asm"
	include "levels/level_05/code/D545-D554__wall_init_face0.asm"
	include "levels/level_05/code/D555-D564__wall_init_face1.asm"
	include "levels/level_05/code/D565-D574__wall_init_face2.asm"
	include "levels/level_05/code/D575-D584__wall_init_face3.asm"
	include "levels/level_05/code/D585-D5A5__unpack_cell_walls.asm"
	include "levels/level_05/code/D5A6-D5C2__render_wall_flags.asm"
	include "levels/level_05/code/D5C3-D5CC__wrap_view_we.asm"
	include "levels/level_05/code/D5CD-D5D6__wrap_view_ns.asm"
	include "levels/level_05/code/D5D7-D5E2__wrap_maze_coord.asm"
	include "levels/level_05/code/D5E3-D6F4__handle_chest.asm"
	include "levels/level_05/code/D6F5-D724__trap_value_tables.asm"
	include "levels/level_05/code/D725-D777__trap_name_table.asm"
	include "levels/level_05/code/D778-D7B5__trap_area_damage.asm"
	include "levels/level_05/code/D7B6-D7CD__wandering_creature_data.asm"
	include "levels/level_05/code/D7CE-D810__handle_wandering_creature.asm"
	include "levels/level_05/code/D811-D828__wc_show_joiner.asm"
	include "levels/level_05/code/D829-D83C__wc_join_scan.asm"
	include "levels/level_05/code/D83D-D84E__wc_join_hero.asm"
	include "levels/level_05/code/D84F-D85C__run_cell_encounter.asm"
	include "levels/level_05/code/D85D-D879__party_has_effect_item.asm"
	include "levels/level_05/code/D87A-D893__prompt_pick_hero.asm"
	include "levels/level_05/code/D894-D89C__trigger_cell_encounter.asm"
	include "levels/level_05/code/D89D-D8BD__start_combat.asm"
	include "levels/level_05/code/D8BE-D8DC__damage_group_checked.asm"
	include "levels/level_05/code/D8DD-D8ED__set_damage_state.asm"
	include "levels/level_05/code/D8EE-D90D__roll_from_daypart_table.asm"
	include "levels/level_05/code/D90E-D91E__point_ix_to_record.asm"
	include "levels/level_05/code/D91F-D94D__announce_stairs.asm"
	include "levels/level_05/code/D94E-D961__draw_view_elements.asm"
	include "levels/level_05/code/D962-DA6D__draw_wall_column.asm"
	include "levels/level_05/code/DA6E-DB07__draw_wall_element.asm"
	include "levels/level_05/code/DB08-DBE6__handle_move_key.asm"
	include "levels/level_05/code/DBE7-DBF7__move_beep.asm"
	include "levels/level_05/code/DBF8-DC02__move_party_forward.asm"
	include "levels/level_05/code/DC03-DC3B__step_in_facing.asm"
	include "levels/level_05/code/DC3C-DC6B__process_turn.asm"
	include "levels/level_05/code/DC6C-DDFB__wall_element_table.asm"

; sprites 00..43 - byte-identical to level_03/04 (verified); single-sourced
sprites:
	include "levels/sewers_sprites.asm"
sprite_44:
	incbin "levels/level_05/data/F098-F0F3__sprite_44.bin"

pixel_shift_table:
	incbin "levels/level_05/data/F0F4-F1DD__pixel_shift_table.bin"

; $F1DE-$F2E9 - level-specific gfx/pixel-translate table (256-byte xlat + maze-row header)
gfx_xlat_table:
	incbin "levels/level_05/data/F1DE-F2E9__gfx_xlat_table.bin"

; $F2EA-$F6B1 - the two 22x22 maze planes (source, DB grids)
	include "levels/level_05/code/F2EA-F6B1__maze_planes.asm"

maze_tail:
	incbin "levels/level_05/data/F6B2-FA3F__maze_tail.bin"

special_loc_list:
	incbin "levels/level_05/data/FA40-FB50__special_loc_list.bin"
overlay_end:					; $FB51
