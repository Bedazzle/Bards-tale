; ============================================================================
; The Bard's Tale (ZX Spectrum) - Level 04 = SEWERS 2
; "There are tracks here, leading east" / "There is no exit until the seven
;  words are said"  (see levels/level_04/TEXT.md, levels/LEVEL_INDEX.md)
; ----------------------------------------------------------------------------
; 14789-byte dungeon overlay, org $C18C. Same FORMAT as the carved level_02/03.
; CARVE STATUS: fully carved + byte-exact. Front matter, handlers, wall_element_table,
; maze planes are source; sprites single-sourced (shared Sewers set). Remaining incbin
; are irreducible data (packed text, maze_tail); level_tbl format cracked ($FC-record
; wall-pattern lists). All 73 handler routines named + @done. See CARVE.md.
;
; Region map (all boundaries measured, byte-exact):
;   $C18C-$C2DF  front_matter: dispatch JP + ADDR_TABLE + addr_table_2 + decoder [source]
;   $C2E0-$C31F  MESSAGES_TABLE (64-byte packed-text length table)      [DB]
;   $C320-$C801  MESSAGES_TEXTS (5-bit packed text bitstream)           [incbin]
;   $C802-$C80F  level_tbl_pad (14 zero bytes)                          [DB]
;   $C810-$D353  level_tbl_1..6 (wall-pattern tables)                   [incbin]
;   $D354-$DDC6  handler code (dispatch + maze/view/movement)           [split source]
;   $DDC7-$DF56  wall_element_table (DW-of-sprite-labels)               [source]
;   $DF57-$F3FF  sprites (sprite_00..43 shared + per-level sprite_44)   [shared source]
;   $F400-$F4E9  pixel_shift_table (engine table, identical across lvls)[incbin]
;   $F4EA-$F8B1  maze planes (MAZE_WALLS + MAZE_FEATURES, DB grids)     [source]
;   $F8B2-$FB50  maze_tail + special_loc_list                          [incbin]
;
; Dispatch JP table (slot roles fixed across all overlays):
;   [0] handle_move_key          $DC63    [3] handle_wandering_creature $D929
;   [1] refresh_dungeon_view     $D568    [4] handle_chest              $D73E
;   [2] process_turn             $DD97    [5] scan_cells_ahead          $D4FD
; ============================================================================

; --- $C18C-$C2DF  front matter (dispatch vectors + ADDR_TABLE + decoder) -----
	include "levels/level_04/code/C18C-C2DF__front_matter.asm"

; --- $C2E0-$C31F  MESSAGES_TABLE: per-message packed length table (64 bytes) --
MESSAGES_TABLE:
		DB $07,$11,$24,$0A,$14,$20,$1A,$79,$07,$0C,$09,$0B,$13,$15,$12,$18
		DB $15,$13,$1B,$76,$20,$18,$0A,$09,$72,$0D,$0B,$04,$17,$09,$42,$09
		DB $35,$1A,$07,$26,$54,$14,$2E,$42,$47,$7F,$7A,$67,$1C,$0D,$0C,$05
		DB $0C,$18,$12,$2F,$2F,$3A,$12,$02,$04,$0B,$00,$00,$00,$00,$00,$00

; --- $C320-$C801  MESSAGES_TEXTS: 5-bit packed bitstream (see decoded.txt) ----
MESSAGES_TEXTS:
	incbin "levels/level_04/data/C320-C801__messages_texts.bin"

; --- $C802-$D353  level_tbl: pad + 6 wall-pattern tables ----------------------
level_tbl_pad:
		DB 0,0,0,0,0,0,0,0,0,0,0,0,0,0
level_tbl_1:
	incbin "levels/level_04/data/C810-C990__level_tbl_1.bin"
level_tbl_2:
	incbin "levels/level_04/data/C991-CB26__level_tbl_2.bin"
level_tbl_3:
	incbin "levels/level_04/data/CB27-CDBE__level_tbl_3.bin"
level_tbl_4:
	incbin "levels/level_04/data/CDBF-CF5C__level_tbl_4.bin"
level_tbl_5:
	incbin "levels/level_04/data/CF5D-D122__level_tbl_5.bin"
level_tbl_6:
	incbin "levels/level_04/data/D123-D353__level_tbl_6.bin"

; --- $D354-$DDC6  handler code (dispatch targets + maze/view/movement) --------
; Split one-file-per-routine (STARThex-ENDhex__name). All 73 named + @done with
; In/Out headers + role-based dot-locals. process_turn ends jp $62aa @ $DDC6;
; gfx starts $DDC7.
; Bootstrapped by tools/regen_level04_handlers.sh (see levels/level_04/CARVE.md).
sewers2_handlers:
	include "levels/level_04/code/D354-D364__get_cell_feature.asm"
	include "levels/level_04/code/D365-D3C6__process_cell_features.asm"
	include "levels/level_04/code/D3C7-D3CC__cell_feature_masks.asm"
	include "levels/level_04/code/D3CD-D3D5__set_state_and_redraw.asm"
	include "levels/level_04/code/D3D6-D3DD__mask_cell_byte.asm"
	include "levels/level_04/code/D3DE-D40C__dispatch_special_location.asm"
	include "levels/level_04/code/D40D-D418__dispatch_scan_loop.asm"
	include "levels/level_04/code/D419-D428__ev_spin_facing.asm"
	include "levels/level_04/code/D429-D432__ev_smoke.asm"
	include "levels/level_04/code/D433-D450__ev_start_encounter.asm"
	include "levels/level_04/code/D451-D455__ev_damage_all.asm"
	include "levels/level_04/code/D456-D45A__ev_inc_2f.asm"
	include "levels/level_04/code/D45B-D45F__ev_inc_3e.asm"
	include "levels/level_04/code/D460-D472__ev_show_number.asm"
	include "levels/level_04/code/D473-D47D__ev_dispatch_smc.asm"
	include "levels/level_04/code/D47E-D48A__ev_dispatch_run.asm"
	include "levels/level_04/code/D48B-D49F__ev_set_flags.asm"
	include "levels/level_04/code/D4A0-D4BF__ev_teleport.asm"
	include "levels/level_04/code/D4C0-D4FC__damage_all_groups.asm"
	include "levels/level_04/code/D4FD-D534__scan_cells_ahead.asm"
	include "levels/level_04/code/D535-D567__announce_nearby.asm"
	include "levels/level_04/code/D568-D572__refresh_dungeon_view.asm"
	include "levels/level_04/code/D573-D5C3__redraw_location.asm"
	include "levels/level_04/code/D5C4-D5D2__maze_cell_addr.asm"
	include "levels/level_04/code/D5D3-D5F6__render_wall_face0.asm"
	include "levels/level_04/code/D5F7-D61A__render_wall_face1.asm"
	include "levels/level_04/code/D61B-D63F__render_wall_face2.asm"
	include "levels/level_04/code/D640-D663__render_wall_face3.asm"
	include "levels/level_04/code/D664-D672__get_walls_e.asm"
	include "levels/level_04/code/D673-D681__get_walls_w.asm"
	include "levels/level_04/code/D682-D690__get_walls_n.asm"
	include "levels/level_04/code/D691-D69F__get_walls_s.asm"
	include "levels/level_04/code/D6A0-D6AF__wall_init_face0.asm"
	include "levels/level_04/code/D6B0-D6BF__wall_init_face1.asm"
	include "levels/level_04/code/D6C0-D6CF__wall_init_face2.asm"
	include "levels/level_04/code/D6D0-D6DF__wall_init_face3.asm"
	include "levels/level_04/code/D6E0-D700__unpack_cell_walls.asm"
	include "levels/level_04/code/D701-D71D__render_wall_flags.asm"
	include "levels/level_04/code/D71E-D727__wrap_view_we.asm"
	include "levels/level_04/code/D728-D731__wrap_view_ns.asm"
	include "levels/level_04/code/D732-D73D__wrap_maze_coord.asm"
	include "levels/level_04/code/D73E-D84F__handle_chest.asm"
	include "levels/level_04/code/D850-D87F__trap_value_tables.asm"
	include "levels/level_04/code/D880-D8D2__trap_name_table.asm"
	include "levels/level_04/code/D8D3-D910__trap_area_damage.asm"
	include "levels/level_04/code/D911-D928__wandering_creature_data.asm"
	include "levels/level_04/code/D929-D983__handle_wandering_creature.asm"
	include "levels/level_04/code/D984-D997__wc_join_scan.asm"
	include "levels/level_04/code/D998-D9A9__wc_join_hero.asm"
	include "levels/level_04/code/D9AA-D9B7__run_cell_encounter.asm"
	include "levels/level_04/code/D9B8-D9C2__party_has_effect_item.asm"
	include "levels/level_04/code/D9C3-D9D4__damage_groups_by_a.asm"
	include "levels/level_04/code/D9D5-D9EE__prompt_pick_hero.asm"
	include "levels/level_04/code/D9EF-D9F7__trigger_cell_encounter.asm"
	include "levels/level_04/code/D9F8-DA0C__start_combat.asm"
	include "levels/level_04/code/DA0D-DA18__print_msg_at_loc.asm"
	include "levels/level_04/code/DA19-DA37__damage_group_checked.asm"
	include "levels/level_04/code/DA38-DA48__set_damage_state.asm"
	include "levels/level_04/code/DA49-DA68__roll_from_daypart_table.asm"
	include "levels/level_04/code/DA69-DA79__point_ix_to_record.asm"
	include "levels/level_04/code/DA7A-DAA8__announce_stairs.asm"
	include "levels/level_04/code/DAA9-DABC__draw_view_elements.asm"
	include "levels/level_04/code/DABD-DBC8__draw_wall_column.asm"
	include "levels/level_04/code/DBC9-DC62__draw_wall_element.asm"
	include "levels/level_04/code/DC63-DD41__handle_move_key.asm"
	include "levels/level_04/code/DD42-DD52__move_beep.asm"
	include "levels/level_04/code/DD53-DD5D__move_party_forward.asm"
	include "levels/level_04/code/DD5E-DD96__step_in_facing.asm"
	include "levels/level_04/code/DD97-DDC6__process_turn.asm"

; --- $DDC7-$DF56  wall_element_table (16 view-slot rows x 5-byte records) ------
	include "levels/level_04/code/DDC7-DF56__wall_element_table.asm"

; --- $DF57-$F3FF  sprite bitmaps (SHARED Sewers set, single-sourced) -----------
sprites:
	include "levels/sewers_sprites.asm"		; sprites 00..43, shared across Sewers 3/4/5
	include "levels/level_04/code/F1F3-F3FF__sprite_44.asm"	; sprite_44 (level-specific backdrop)

; --- $F400-$F4E9  pixel_shift_table (engine table, level-independent) ---------
; @done  pixel bit-position translate table (byte-identical across all levels).
pixel_shift_table:
	incbin "levels/level_04/data/F400-F4E9__pixel_shift_table.bin"

; --- $F4EA-$F8B1  the two 22x22 maze planes (MAZE_WALLS + MAZE_FEATURES) -------
	include "levels/level_04/code/F4EA-F8B1__maze_planes.asm"

; --- $F8B2-$FA3F  maze_tail (sparse per-cell overlay, mostly zero) -------------
; @wip  sparse data between MAZE_FEATURES and special_loc_list.
maze_tail:
	incbin "levels/level_04/data/F8B2-FA3F__maze_tail.bin"

; --- $FA40-$FB50  special_loc_list (ADDR_TABLE slot $58) ----------------------
; @done  flat 2-byte {SO_NO,WE_EA} cell entries partitioned by special_dispatch_table;
; dispatch_special_location scans it for the party cell to fire an event. $FF = empty.
special_loc_list:
	incbin "levels/level_04/data/FA40-FB50__special_loc_list.bin"
overlay_end:					; $FB51 - one past the overlay
